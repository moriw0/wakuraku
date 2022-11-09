class CreateReservations < ActiveRecord::Migration[6.1]
  def change
    create_table :reservations do |t|
      t.references :user
      t.references :event, null: false, foreign_key: true, index: false
      t.string :comment
      t.integer :guest_number
      t.boolean :is_canceled, default: false
      t.timestamps
    end

    add_index :reservations, %i[event_id user_id], unique: true
  end
end
