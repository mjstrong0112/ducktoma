require 'views/views_helper'

describe "adoptions/show.html.haml" do
  before do
    @adoption = assign(:adoption, Fabricate(:adoption))
  end

  it "contains the raffle number" do
    render    
    rendered.should have_selector('#raffle-number', :content => @adoption.raffle_number)
  end

  it "contains a print button" do
    render
    rendered.should have_selector('#print', :class => "blue-button")
  end

  it "contains total (fee)" do
    render
    rendered.should have_selector('div', :content => (@adoption.fee/100).to_s)
  end
end
