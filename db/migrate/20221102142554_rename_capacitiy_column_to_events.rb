class RenamecapacityColumnToEvents < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :capacity, :capacity
  end
end
