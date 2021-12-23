require "test_helper"

class SearchTest < ActiveSupport::TestCase
  test "empty search mustn't be accepted" do
    search = Search.new
    refute search.valid?
  end

  test 'valid search should be accepted' do
    search = searches(:one)
    assert search.valid?
    search = searches(:two)
    assert search.valid?
    search = searches(:three)
    assert search.valid?
  end
end
