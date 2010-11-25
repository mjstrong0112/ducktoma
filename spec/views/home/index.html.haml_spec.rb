require 'views/views_helper'

describe "home/index.html.haml" do
  it "renders a default index page" do
    render
    check do
      h1(:content => 'Adopt a Duck Now!')
    end
  end
end
