json.extract! card, :id, :word, :user_id, :definition, :created_at, :updated_at
json.url card_url(card, format: :json)
