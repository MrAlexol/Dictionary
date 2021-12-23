require 'test_helper'

class WordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @word = words(:one)
  end

  test 'should search words when getting index' do
    search_phrase = 'food'
    get words_url, params: { search: { phrase: search_phrase, part_of_speech: 'all' }, format: :json }
    assert_redirected_to Word.search(search_phrase)
  end

  test "shouldn't search words without any params" do
    get words_url, params: { format: :json }
    assert_response 204
  end

  test 'should show word in json' do
    get "#{words_url}/#{@word.id}", params: { format: :json }
    assert_response :success
  end
end
