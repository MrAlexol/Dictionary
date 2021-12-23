require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @params = 'locale=en'
  end

  test 'any user can see the search page' do
    get "#{root_url}?#{@params}"
    assert_select 'h3', 'Search a word'
    sign_in users(:one)
    assert_select 'h3', 'Search a word'
  end

  test 'authorized user can see his cards' do
    sign_in users(:two)
    get cards_path
    assert_response :success
  end

  test "unauthorized user can't see cards page" do
    get cards_url
    assert_response :found
    assert_redirected_to new_user_session_path
  end

  test "after logging out user won't see his cards" do
    sign_in users(:two)
    get cards_path
    delete destroy_user_session_url
    assert_redirected_to root_url
  end

  test 'user can learn any his card' do
    sign_in users(:two)
    get "#{cards_path}/#{cards(:one).id}"
    assert_response :success
  end
end
