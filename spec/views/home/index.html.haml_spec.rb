require 'views/views_helper'

describe "home/index.html.haml" do
  it "renders a default index page" do
    render
    check do
      h1(:content => 'Home#index')
      p(:content => 'Find me in app/views/home/index.html.haml')
    end
  end
end
