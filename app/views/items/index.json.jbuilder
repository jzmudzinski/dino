json.set! :offers do
  json.array!(@items) do |item|
    json.id item.item_id
    json.title item.item_name
    json.imageUrl item.item_image2
    json.price item.item_price
    json.endAt item.item_ending_time - Time.now.to_i
  end
end
