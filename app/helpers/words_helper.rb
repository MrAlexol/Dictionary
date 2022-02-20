module WordsHelper
  def find_word(input)
    return Word.search(input) if Word.search(input)

    result = Word.all.inject({}) do |acc, record|
      acc.merge({ record.phrase => DamerauLevenshtein.distance(record.phrase, input) })
    end.filter { |_key, val| val <= 1 }
    result.length == 1 ? Word.search(result.keys[0]) : result
  end
end
