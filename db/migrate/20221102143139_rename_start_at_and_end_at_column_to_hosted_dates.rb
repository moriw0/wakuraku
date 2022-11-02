class RenameStartAtAndEndAtColumnToHostedDates < ActiveRecord::Migration[6.1]
  def change
    rename_column :hosted_dates, :started_at, :started_at
    rename_column :hosted_dates, :ended_at, :ended_at
  end
end
