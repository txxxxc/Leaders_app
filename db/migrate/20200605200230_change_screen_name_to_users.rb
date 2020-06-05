class ChangeScreenNameToUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :screen_name, :string, null: false
  end
end
