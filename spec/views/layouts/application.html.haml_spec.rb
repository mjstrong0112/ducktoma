require 'views/views_helper'

describe "layouts/application.html.haml" do
  before do
    # Stub out signed in to avoid loading devise
    stub(view).user_signed_in? {false}
  end
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
  it "renders the sign up and sign in links if logged out" do
    mock(view).user_signed_in? { false }
    render
    # Assign tmp vars for azebiki
    new_session_path = new_user_session_path
    new_registration_path = new_user_registration_path
    check do
      a(:content => "Sign In", :href => new_session_path)
      a(:content => "Sign Up", :href => new_registration_path)
    end
    check_not { a(:content => "Sign Out") }
  end
  it "renders the sign out link if logged in" do
    mock(view).user_signed_in? { true }
    render
    check_not do
      a(:content => "Sign In")
      a(:content => "Sign Up")
    end
    destroy_path = destroy_user_session_path
    check do
      a(:content => "Sign Out", :href => destroy_path)
    end
  end
end