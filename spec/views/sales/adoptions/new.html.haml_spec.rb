require 'views/views_helper'

describe "sales/adoptions/new.html.haml" do
  before(:each) { assign(:adoption, Adoption.new) }
  context "form" do
    it "should have the right fields" do
      render
      fields = %w(full_name phone email address city zip)
      fields.each do |field|
        rendered.should have_selector('input', :name => 'adoption[adopter_info_attributes]['+field+']')
      end
    end
    it "should have a submit button" do
      render
      rendered.should have_selector('#submit-sales')
    end
  end
end
