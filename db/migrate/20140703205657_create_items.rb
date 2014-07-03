class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.integer :offer_id
      t.decimal :price
      t.string :image_url

      t.timestamps
    end
  end
end
