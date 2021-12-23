class Search < ApplicationRecord
  validates :phrase, presence: true
  validates :part_of_speech, presence: true
end
