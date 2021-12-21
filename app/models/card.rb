class Card < ApplicationRecord
  belongs_to :user
  validates :word, presence: true
  validates :definition, presence: true
end
