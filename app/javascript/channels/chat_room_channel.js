import consumer from "./consumer"

const createChatRoomChannel = (roomId) => {
  return consumer,subscriptions.create({ channel: "ChatRoomChannel", room_id: roomId }, {
    received(data) {
      const messagesContainer = document.getElementById("messages");
      if (messagesContainer) {
        messagesContainer.insertAdjacentHTML("beforeend",
          `<div class="p-2 bg-gray-100 rounded-md my-1">
            <strong>${data.user}:</strong> ${data.message}
          </div>`
        );
      }
    },

    sendMessage(message) {
      this.perform("receive", { message, room_id: roomId });
    }
  });
};

document.addEventListener("DOMContentLoaded", () => {
  const chatRoomId = document.getElementById("chat-room-id")?.value;
  if (chatRoomId) {
    const chatChannel = createChatRoomChannel(chatRoomId);
    const messageInput = document.getElementById("message-input");
    const sendButton = document.getElementById("send-button");

    if (messageInput && sendButton) {
      sendButton.addEventListener("click", () => {
        
      })
    }
  }
})

consumer.subscriptions.create("ChatRoomChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  }
});
