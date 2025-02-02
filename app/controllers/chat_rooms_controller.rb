class ChatRoomsController < ApplicationController
    before_action :authenticate_user!

    def index
        @chat_rooms = current_user.chat_rooms
    end

    def show
        @chat_room = ChatRoom.find(params[:id])
        @messages = @chat_room.messages.includes(:user)
    end

    # 1on1
    def create_private
        other_user = User.find(params[:user_id])
        chat_room = ChatRoom.find_or_create_by(room_type: "private") do |room|
            room.users << [ current_user, other_user ]
        end
        redirect_to chat_rooms_path(chat_room)
    end

    # グループ
    def create_group
        chat_room = ChatRoom.create!(room_type: "group")
        chat_room.users << current_user
        chat_room.users << User.where(id: params[:user_id])
        redirect_to chat_rooms_path(chat_room)
    end
end
