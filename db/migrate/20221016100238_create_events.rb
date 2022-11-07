class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.bigint :owner_id
      t.string :name, null: false
      t.string :place, null: false
      t.string :title, null: false
      t.text :discription, null: false
      t.string :thumbnail_url
      t.integer :price, null: false
      t.integer :required_time, null: false
      t.boolean :is_published, null: false
      t.integer :capacitiy, null: false

      t.timestamps
    end

    add_index :events, :owner_id
  end
end
