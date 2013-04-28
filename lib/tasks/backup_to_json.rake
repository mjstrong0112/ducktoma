
desc "Backup database content to JSON"
task :backup_to_json => :environment do
  documents = [Adoption, Duck, Location, Organization, PaymentNotification, Pricing, SalesEvent, User]
  documents.each do |d|
    f = File.open("#{Rails.root}/backup/#{d.to_s.underscore}.json", 'w')
    f << d.all.to_a.to_json
    f.close
  end  
end


