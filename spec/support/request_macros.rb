module RequestMacros
  def in_session(name)
    Capybara.session_name = name
    yield
  end
  
  def login(user = create(:user))
    visit login_path
    fill_in :email, with: user.email
    fill_in :password, with: user.password
    click_button :login
    user
  end
  
  def refresh
    visit(current_path)
  end
end