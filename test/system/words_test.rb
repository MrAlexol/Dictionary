require "application_system_test_case"

class WordsTest < ApplicationSystemTestCase
  setup do
    @params = 'locale=en'
  end

  test 'checking the right definition of a Word' do
    visit "#{root_url}?#{@params}"
    fill_in 'search_phrase', with: 'complicated'
    click_on 'Search'
    definition = find('#def_row_0_0_0').text

    assert_equal 'consisting of many interconnecting parts or elements; intricate.', definition
  end

  test 'searching a Word' do
    visit "#{root_url}?#{@params}"
    fill_in 'search_phrase', with: 'complicated'
    click_on 'Search'
    found_word = find('tr', match: :first).text.gsub(/ .*/, '')

    assert_equal 'complicated', found_word
  end

end
