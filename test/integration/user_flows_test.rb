require 'test_helper'

class UserFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'any user can see the search page' do
    get root_url
    assert_response :success
    assert_select 'h3', 'Search a word'
    sign_in users(:one)
    assert_response :success
    assert_select 'h3', 'Search a word'
  end

  test 'users with different locales will see different titles' do
    sign_in users(:one)
    get root_url
    assert_select 'h3', 'Search a word'
    sign_in users(:two)
    get root_url
    assert_select 'h3', 'Поиск слова'
  end

  test 'authorized user can see his cards' do
    sign_in users(:one)
    get cards_url
    assert_response :success
    assert_select 'h3', 'My cards'
  end

  test "unauthorized user can't see cards page" do
    get cards_url
    assert_response :found
    assert_redirected_to new_user_session_url
  end

  test "after logging out user won't see his cards" do
    sign_in users(:one)
    get cards_url
    assert_select 'h3', 'My cards'
    delete destroy_user_session_url
    assert_redirected_to root_url
  end

  test 'user can learn any his card' do
    sign_in users(:one)
    get card_url(cards(:two).id)
    assert_response :success
    assert_select 'div', 'Guess this word'
  end
end
