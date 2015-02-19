json.array!(@private_messages) do |private_message|
  json.extract! private_message, :id, :title, :text, :file
  json.url private_message_url(private_message, format: :json)
end
