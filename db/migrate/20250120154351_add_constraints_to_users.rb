class AddConstraintsToUsers < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :name, false
    change_column_null :users, :email, false
    add_index :users, :email, unique: true
  end
end
