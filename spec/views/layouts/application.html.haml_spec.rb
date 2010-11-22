require 'views/views_helper'

describe "layouts/application.html.haml" do
  it "renders the title" do
    render
    check { head { title(:content => 'Ducktoma') } }
  end
  it "renders the csrf meta tags" do
    # mock out forgery for testing
    mock(view).protect_against_forgery?{true}
    render
    check do
      head do
        meta(:name => "csrf-param")
        meta(:name => "csrf-token")
      end
    end
  end
  it "renders the flash" do
    flash[:notice] = "Testing notice"
    flash[:alert] = "Testing alert"
    mock.proxy(view).notice
    mock.proxy(view).alert
    render
    check do
      p(:class => ['notice'], :content => "Testing notice")
      p(:class => ['alert'], :content => "Testing alert")
    end
  end
end