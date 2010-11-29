require 'views/views_helper'

describe "adoptions/show.html.haml" do
  before do
    @adoption = assign(:adoption, Fabricate(:adoption))
  end

  it "should contain the raffle number" do
    render    
    rendered.should have_selector('#raffle-number', :content => @adoption.raffle_number)
  end

  it "should contain a print button" do
    render
    rendered.should have_selector('#print', :class => "blue-button")
  end

  it "should contain total" do
    render
    rendered.should have_selector('div', :content => @adoption.fee.to_s)
  end
end
