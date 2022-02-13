require 'test_helper'

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test 'any user should get new' do
    get searches_new_url
    assert_response :success
  end

  test 'any user should get show' do
    get searches_show_url
    assert_response :success
  end
end
