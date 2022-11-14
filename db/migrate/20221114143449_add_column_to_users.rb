class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nickname, :string
    add_column :users, :phone_number, :string
    add_column :users, :profile, :text
  end
end
