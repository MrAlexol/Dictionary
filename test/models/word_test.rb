require "test_helper"

class WordTest < ActiveSupport::TestCase
  test "empty word mustn't be saved" do
    word = Word.new
    refute word.save
  end

  test 'valid word should be saved' do
    word = words(:one)
    assert word.save
  end

  test 'valid word without "groups" field should be saved' do
    word = words(:three)
    assert word.save
  end

  test "invalid word mustn't be saved" do
    word = words(:one)
    word.phrase = ''
    refute word.save
  end
end
