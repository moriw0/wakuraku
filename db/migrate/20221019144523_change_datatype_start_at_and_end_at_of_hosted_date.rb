class ChangeDatatypeStartAtAndEndAtOfHostedDate < ActiveRecord::Migration[6.1]
  def change
    change_column :hosted_dates, :start_at, :datetime
    change_column :hosted_dates, :end_at, :datetime
  end
end
