require 'views/views_helper'

describe "admin/adoptions/index.html.haml" do
  before(:each) do
    @collection = []
    (1..50).to_a.each do |n|
      @collection.push Fabricate.build(:adoption)
    end
    stub(view).collection { @collection }
  end
  it "displays the information for all adoptions" do
    render
    @collection.each do |adoption|
      rendered.should have_selector('td', :content => adoption.raffle_number)
      rendered.should have_selector('td', :content => number_to_currency(adoption.fee))
      rendered.should have_selector('td', :content => adoption.duck_count.to_s)
    end
  end
  it "has a total ducks adopted" do
    render
    rendered.should have_selector('h2', :content => 'Total ducks adopted')
  end
  it "has a total donations raised" do
    render
    rendered.should have_selector('h2', :content => 'Total donations raised')
  end
end