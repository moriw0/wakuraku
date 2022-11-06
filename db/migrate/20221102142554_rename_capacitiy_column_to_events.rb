class RenameCapacitiyColumnToEvents < ActiveRecord::Migration[6.1]
  def change
    rename_column :events, :capacitiy, :capacity
  end
end
