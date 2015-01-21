require 'test_helper'

class UserAuthorizationTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  attr_reader :user

  def setup
    @user = User.create(username: 'user',
    password: 'password',
    first_name: 'John',
    last_name: 'Doe',
    email: 'example@example.com')
    visit root_url
  end

  test ''
end
