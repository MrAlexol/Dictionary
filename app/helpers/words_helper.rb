module WordsHelper
  def make_word_list(input)
    Word.all.inject({}) do |acc, record|
      acc.merge({ record.phrase => DamerauLevenshtein.distance(record.phrase, input) })
    end.filter { |_key, val| val <= 1 }
    #{ word_list: input }
  end
end
