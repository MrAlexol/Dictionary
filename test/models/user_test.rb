require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "empty user mustn't be saved" do
    user = User.new
    refute user.save
  end

  test 'valid user should be saved' do
    user = users(:one)
    assert user.save
  end

  test "invalid user mustn't be saved" do
    user = users(:one)
    user.email = 'not_valid'
    refute user.save
  end
end
