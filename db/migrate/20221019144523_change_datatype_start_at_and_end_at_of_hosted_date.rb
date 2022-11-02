class ChangeDatatypeStartAtAndEndAtOfHostedDate < ActiveRecord::Migration[6.1]
  def change
    change_column :hosted_dates, :started_at, :datetime
    change_column :hosted_dates, :ended_at, :datetime
  end
end
