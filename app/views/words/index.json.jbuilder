if @error
  json.error true
  json.message @message
else
  json.merge! @found
end
