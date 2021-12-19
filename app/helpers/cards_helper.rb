module CardsHelper
  def get_random_card
    Card.where(user_id: current_user)[rand * Card.where(user_id: current_user).count]
  end

  def make_respond(input, correct)
    correct.gsub!(/ \(.*\)/, '')
    return {status: 'correct'} if correct == input.strip

    {
      status: :incorrect,
      DL_distance: DamerauLevenshtein.distance(correct, input),
      answer: correct
    }
  end
end
