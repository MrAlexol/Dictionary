# frozen_string_literal: true

require 'application_system_test_case'

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

  test 'checking the right group list of a Word' do
    visit "#{root_url}?#{@params}"
    fill_in 'search_phrase', with: words(:two).phrase
    click_on 'Search'

    words(:two).groups.split('|').map do |elem|
      assert_text elem
    end
  end

  test 'searching a Word' do
    visit "#{root_url}?#{@params}"
    fill_in 'search_phrase', with: words(:one).phrase
    click_on 'Search'
    found_word = find('#word_row_0_0', match: :first).text.gsub(/ .*/, '')

    assert_equal words(:one).phrase, found_word
  end

  test 'searching a Word with a certain Part of Speech' do
    visit "#{root_url}?#{@params}"
    fill_in 'search_phrase', with: words(:four).phrase
    click_on 'Search'
    select 'Noun', from: 'search_part_of_speech'
    click_on 'Search'

    sleep 0.1 while find('#search_submit').disabled?

    assert_equal "#{words(:four).phrase} (noun)", find('.word_row', match: :first).text
  end
end
