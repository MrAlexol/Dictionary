# frozen_string_literal: true

# Capybara github: https://github.com/teamcapybara/capybara

require 'application_system_test_case'

class CardsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:one)
    sign_in @user
  end

  test 'visiting the index' do
    visit cards_url
    assert_text 'My cards'
  end

  test 'creating a Card' do
    visit root_url
    fill_in 'search_phrase', with: 'food'
    click_on 'Search'
    find('.word_definition', match: :first).click

    visit cards_url
    assert_text 'food'
  end

  test 'learning a Card with correct answer' do
    visit cards_url

    element = find('.word_phrase', match: :first)
    word = element.text.gsub(/ \(.*\)/, '')
    element.click

    fill_in 'card_word', with: word
    click_on 'check_submit'

    result = find('#result_footer').text

    assert_equal 'Correct!', result
  end

  test 'learning a Card with almost correct answer' do
    visit cards_url

    element = find('.word_phrase', match: :first)
    word = element.text.gsub(/ \(.*\)/, '')
    element.click

    fill_in 'card_word', with: word.chop
    click_on 'check_submit'

    result = find('#result_footer').text

    assert_equal "Almost correct! The right answer is #{word}", result
  end

  test 'learning a Card with incorrect answer' do
    visit cards_url

    find('.word_phrase', match: :first).click

    fill_in 'card_word', with: 'not correct answer'
    click_on 'check_submit'

    result = find('#result_footer', match: :first).text

    assert_equal 'Incorrect!', result
  end

  test 'destroying a Card' do
    visit cards_url
    click_on 'Delete', match: :first

    assert_text 'Card has been deleted'
  end
end
