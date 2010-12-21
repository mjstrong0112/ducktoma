require 'views/views_helper'

describe "adoptions/new.html.haml" do
  before(:each) { assign(:adoption, Adoption.new) }

  it "should have a submit button" do
    render
  end
end