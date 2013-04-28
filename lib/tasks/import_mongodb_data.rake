desc "Import mongodb data"
task import_mongodb_data: :environment do

  @adopter_infos = []
  @payer_infos = []  
  @bson_ids = {}

  def parse_json klass, &block
    klass_name = klass.to_s.underscore
    url = "#{Rails.root}/lib/assets/backup/#{klass_name}.json"
    json_string = File.open(url, 'rb') { |f| f.read }
    @bson_ids[klass_name] = {}

    JSON.parse(json_string).each do |document|
      bson_id = document.delete "_id"      
      object = yield document, bson_id

      begin
        object.save(validate: false)
        @bson_ids[klass_name][bson_id] = object.id
      rescue
        binding.pry
      end
 
    end
  end

  parse_json User do |json|
    if json["role_strings"] && json["role_strings"].include?("admin")
      json["role"] = "admin"
    elsif json["role_strings"] && json["role_strings"].include?("sales_rep")
      json["role"] = "sales_rep"
    end
    json.delete("role_strings")
    json.delete("password_salt")
    json.delete("remember_token")
    User.new json, without_protection: true
  end

  parse_json Pricing do |json|
    Pricing.new json, without_protection: true
  end
  
  parse_json Location do |json|    
    Location.new json, without_protection: true
  end

  parse_json Organization do |json|    
    Organization.new json, without_protection: true
  end

  parse_json SalesEvent do |json|
    organization = json.delete('organization')
    location = json.delete('location')
    json['organization_id'] = Organization.find_by_name(organization).id if not organization.blank?
    json['location_id'] = Location.find_by_name(location).id if not location.blank?
    SalesEvent.new json, without_protection: true
  end

  PaymentNotification.reset_callbacks :create
  parse_json PaymentNotification do |json, bson_id|
    if not json["payer_info"].blank?
      json["payer_info"]["notification_id"] = bson_id
      @payer_infos.push json.delete("payer_info")
    end
    PaymentNotification.new json, without_protection: true  
  end

  parse_json Adoption do |json, bson_id|
    json["user_id"] = @bson_ids["user"][json["user_id"]]
    json["sales_event_id"] = @bson_ids["sales_event"][json["sales_event_id"]]    
    json["club_id"] = @bson_ids["organization"][json.delete("organization_id")] 
    json["payment_notification_id"] = @bson_ids["payment_notification"][json["payment_notification_id"]] 

    json["number"] = json.delete("adoption_number")
    json["sales_type"] = json.delete("type")

    if not json["adopter_info"].blank?
      json["adopter_info"]["adoption_id"] = bson_id
      @adopter_infos.push json.delete("adopter_info")
    end

    Adoption.new json, without_protection: true
  end

  parse_json Duck do |json|
    json["adoption_id"] = @bson_ids["adoption"][json["adoption_id"]]
    Duck.new json, without_protection: true    
  end

  @adopter_infos.each do |info|
    info.delete("_id")
    info["contact_id"] = @bson_ids["adoption"][info.delete("adoption_id")]
    info["contact_type"] = "Adoption"
    ContactInfo.create info, validate: false, without_protection: true
  end

  @payer_infos.each do |info|
    info.delete("_id")
    info["contact_id"] = @bson_ids["payment_notification"][info.delete("notification_id")]
    info["contact_type"] = "PaymentNotification"
    ContactInfo.create info, validate: false, without_protection: true
  end  

  User.all.each { |u| u.password = "sertoma123"; u.password_confirmation = "sertoma123"; u.save }
end