require 'views/views_helper'

describe "sales/adoptions/new.html.haml" do
  before(:each) {
    adoption = Adoption.new
    adoption.adopter_info = ContactInfo.new
    assign(:adoption, adoption)
  }
  context "form" do
    it "should have the right fields" do
      mock(view).parent?{false}
      render
      fields = %w(full_name phone email address city zip)
      fields.each do |field|
        rendered.should have_selector('input', :name => 'adoption[adopter_info_attributes]['+field+']')
      end
    end
    it "should have a submit button" do
      mock(view).parent?{false}
      render
      rendered.should have_selector('#submit-sales')
    end
  end
end
