class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat_room = ChatRoom.find(params[:chat_room_id])
    @message = @chat_room.messages.create!(content: params[:content], user: current_user)

    Rails.logger.info "📢 Broadcasting message: #{@message.content} from user: #{@message.user.name} to chat_room_#{@chat_room.id}"

    ActionCable.server.broadcast("caht_room_#{@chat_room.id}", {
      message: @message.content,
      user: @message.user.name
    })
    head :ok
  end
end
