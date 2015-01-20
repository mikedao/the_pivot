require 'test_helper'

class GuestUserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL

  test 'a guest user can view home page' do
    visit root_path
    assert page.has_content?('Coffee House')
  end
end
