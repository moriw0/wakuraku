class RenameStartAtAndEndAtColumnToHostedDates < ActiveRecord::Migration[6.1]
  def change
    rename_column :hosted_dates, :start_at, :started_at
    rename_column :hosted_dates, :end_at, :ended_at
  end
end
