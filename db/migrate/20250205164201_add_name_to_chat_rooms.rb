class AddNameToChatRooms < ActiveRecord::Migration[7.2]
  def change
    add_column :chat_rooms, :name, :string
  end
end
