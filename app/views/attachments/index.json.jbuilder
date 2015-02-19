json.array!(@attachments) do |attachment|
  json.extract! attachment, :id, :code_id, :image
  json.url attachment_url(attachment, format: :json)
end
