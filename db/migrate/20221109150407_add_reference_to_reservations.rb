class AddReferenceToReservations < ActiveRecord::Migration[6.1]
  def change
    add_reference  :reservations, :hosted_date, null: false, foreign_key: true, default: 14
    change_column_default  :reservations, :hosted_date_id, from: 14, to: nil
  end
end
