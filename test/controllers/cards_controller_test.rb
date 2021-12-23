require 'test_helper'

class CardsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @card = cards(:one)
    @user = users(:one)
  end

  test 'authorized user should get index' do
    sign_in @user
    get cards_url
    assert_response :success
  end

  test "unauthorized user shouldn't get index" do
    get cards_url
    assert_redirected_to new_user_session_url
  end

  test 'should create card' do
    sign_in @user
    assert_difference('Card.count') do
      post cards_url, params: { card: { definition: @card.definition,
                                        user_id: @card.user_id,
                                        word: @card.word } }
    end
    assert_response :success
  end

  test 'user should show his card' do
    sign_in @user
    get card_url(@card)
    assert_response :success
  end

  test 'user should destroy his card' do
    sign_in @user
    assert_difference('Card.count', -1) do
      delete card_url(@card)
    end

    assert_redirected_to cards_url
  end
end
