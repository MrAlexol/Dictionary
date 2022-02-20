if @error
  json.error true
  json.message @message
else
  json.own @word.to_json
  json.api @word_api
end
