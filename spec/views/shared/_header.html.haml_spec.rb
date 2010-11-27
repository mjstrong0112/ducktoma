require 'views/views_helper'

describe "shared/_header.html.haml" do
  before(:each) do
    # Stub out signed in to avoid loading devise
    stub(view).user_signed_in? {false}
  end
  it "renders the sign in link if logged out" do
    mock(view).user_signed_in? { false }
    render
    # Assign tmp vars for azebiki
    new_session_path = new_user_session_path
    destroy_path = destroy_user_session_path    

    check do a(:href => new_session_path) end
    check_not do a(:href => destroy_path) end
  end
  it "renders the sign out link if logged in" do
    mock(view).user_signed_in? { true }
    render

    # Assign tmp vars for azebiki
    new_session_path = new_user_session_path
    destroy_path = destroy_user_session_path

    check_not do a(:href => new_session_path) end
    check do a(:href => destroy_path) end
  end
end