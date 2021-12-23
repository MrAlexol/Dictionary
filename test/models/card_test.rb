require 'test_helper'

class CardTest < ActiveSupport::TestCase
  test "empty card mustn't be saved" do
    card = Card.new
    refute card.save
  end

  test 'valid card should be saved' do
    card = cards(:one)
    assert card.save
  end

  test 'card should be saved and read' do
    card = cards(:two)
    assert card.save
    assert Card.find_by(id: card.id)
  end
end
