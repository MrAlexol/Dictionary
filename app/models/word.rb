class Word < ApplicationRecord
  validates :phrase, presence: true

  def self.dedupe
    # find all models and group them on keys which should be common
    grouped = all.group_by{ |model| [model.phrase] }
    grouped.values.each do |duplicates|
      duplicates.shift # keep the first word
      # if there are any more left, they are duplicates
      # so delete all of them
      duplicates.each { |el| el.destroy } # duplicates can now be destroyed
    end
  end

  def self.search(search)
    find_by phrase: search if search
  end
end
