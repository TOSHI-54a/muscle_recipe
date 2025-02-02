class ChatRoomChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    chat_room = ChatRoom.find(params[:room_id])
    # チャットルームごとに WebSocket ストリームを作成
    stream_from "chat_room_#{chat_room.id}"
  end

  def receive(data)
    chat_room = ChatRoom.find(data["room_id"])
    message = chat_room.messages.create!(content: data["message"], user: current_user)
    ActionCable.server.broadcast("chat_room_#{chat_room.id}", {
      message: message.content,
      user: message.user.name
    })
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
