class Search < ApplicationRecord
  self.inheritance_column = 'not_sti'

  def search_word
    word = Word.all

    word = word.where(phrase: phrase)


    word
  end 
end
