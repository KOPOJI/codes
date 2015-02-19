json.array!(@codes) do |code|
  json.extract! code, :id, :code, :code_url, :status
  json.url code_url(code, format: :json)
end
