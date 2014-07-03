json.array!(@offers) do |offer|
  json.extract! offer, :id, :title, :offer_id, :price, :image_url
  json.url offer_url(offer, format: :json)
end
