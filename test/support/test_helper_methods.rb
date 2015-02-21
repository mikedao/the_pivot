module TestHelperMethods
  def register_user(user)
    fill_in 'session[username]', with: user.username
    fill_in 'session[password]', with: user.password
    click_button 'Login'
  end
end
