require 'views/views_helper'

describe "adoptions/new.html.haml" do
  it "has a box to enter the number of ducks you want to adopt" do
    render
    check do
      form(:id => 'duck-form') do
        input(:type => 'text', :id => 'duck-count-input')
      end
    end
  end
end