require 'spec_helper'

describe "About" do
  it "saves entry" do
    login
    user = create(:user)
    path = about_user_path(user)
    visit path
    if expect(page).to have_field(:about_us_entry_text)
      fill_in :about_us_entry_text, with: "hello world"
      find("[type=submit]").click
      expect(current_path).to eq(path)
      expect(page).to have_content("hello world")
    end
  end
  
  it "does not show text field when author is user" do
    user = login
    visit about_user_path(user)
    expect(page).to_not have_field(:text)
  end
  
  it "does deny access to restricted actions" do
    
  end
end