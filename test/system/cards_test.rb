require "application_system_test_case"

class CardsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    # @card = cards(:one)
    @user = users(:one)
    sign_in @user
  end

  test 'visiting the index' do
    visit cards_url
    assert_selector 'h3', text: 'My cards'
  end

  test 'creating a Card' do
    visit root_url
    fill_in 'search_phrase', with: 'string'
    click_on 'Search'
    find('.word_definition', match: :first).click

    visit cards_url
    assert_text 'string'
  end

  test 'learning a Card with correct answer' do
    visit cards_url
    word = find('td', match: :first).text

    click_on 'Learn', match: :first

    fill_in 'card_word', with: word.gsub(/ \(.*\)/, '')
    click_on 'check_submit'

    result = find('#result_footer').text

    assert_equal 'Correct!', result
  end

  test 'learning a Card with almost correct answer' do
    visit cards_url
    word = find('td', match: :first).text.gsub(/ \(.*\)/, '')

    click_on 'Learn', match: :first

    fill_in 'card_word', with: word.chop
    click_on 'check_submit'

    result = find('#result_footer', match: :first).text

    assert_equal "Almost correct! The right answer is #{word}", result
  end

  test 'learning a Card with incorrect answer' do
    visit cards_url
    word = 'not_correct_answer'

    click_on 'Learn', match: :first

    fill_in 'card_word', with: word
    click_on 'check_submit'

    result = find('#result_footer', match: :first).text

    assert_equal 'Incorrect!', result
  end

  test 'destroying a Card' do
    # @card = cards(:three)
    # @card.save
    visit cards_url
    click_on 'Delete', match: :first

    assert_text 'Card was successfully destroyed'
  end
end
