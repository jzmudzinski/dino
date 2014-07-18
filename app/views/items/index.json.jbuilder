json.set! :offers do
  json.array!(@items) do |item|
    json.id item.item_id
    json.title item.item_name
    json.imageUrl item.item_image2
    json.price item.item_price
    json.endAt item.item_ending_time
    json.isBuyNow item.item_is_buy_now_active
  end
end
