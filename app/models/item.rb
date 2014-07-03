class Item < ActiveRecord::Base
  establish_connection(:data)
  self.table_name = 'items'
end
