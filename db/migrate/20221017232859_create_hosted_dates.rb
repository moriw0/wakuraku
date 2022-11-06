class CreateHostedDates < ActiveRecord::Migration[6.1]
  def change
    create_table :hosted_dates do |t|
      t.references :event, null: false, foreign_key: true
      t.date :start_at, null: false
      t.date :end_at, null: false

      t.timestamps
    end
  end
end
