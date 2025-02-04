import consumer from "./consumer";

console.log("Consumer object:", consumer);

const createChatRoomChannel = (roomId) => {
  return consumer.subscriptions.create({ channel: "ChatRoomChannel", room_id: roomId }, {
    received(data) {
      console.log("📩 New message received:", data); // デバッグ用
      const messagesContainer = document.getElementById("messages");
      if (messagesContainer) {
        const currentUserId = document.getElementById("messages");
        const isCurrentUser = data.user_id == currentUserId;
        const messageClass = isCurrentUser ? "bg-green-200 text-right" : "bg-gray-100 text-left";
        messagesContainer.insertAdjacentHTML("beforeend",
          `<div class="p-2 bg-gray-100 rounded-md my-1">
            <strong>${data.user}:</strong> ${data.message}
          </div>`
        );
        scrollToBottom();
      }
    },

    sendMessage(message) {
      console.log("Sending message:", message);
      this.perform("receive", { message, room_id: roomId });
    }
  });
};

document.addEventListener("DOMContentLoaded", () => {
  const chatRoomId = document.getElementById("chat-room-id")?.value;
  if (chatRoomId) {
    console.log(`Intitalizing ChatRoomChannel for room ID: ${chatRoomId}`);
    const chatChannel = createChatRoomChannel(chatRoomId);
    const messageInput = document.getElementById("message-input");
    const sendButton = document.getElementById("send-button");

    if (messageInput && sendButton) {
      sendButton.addEventListener("click", () => {
        const message = messageInput.value.trim();
        if (message !== "") {
          chatChannel.sendMessage(message);
          messageInput.value = "";
        }
      });
    }
  }
});

const scrollToBottom = () => {
  const messagesContainer = document.getElementById("messages");
  if (messagesContainer) {
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
  }
};

document.addEventListener("DOMContentLoaded", () => {
  scrollToBottom();
});

// consumer.subscriptions.create("ChatRoomChannel", {
//   connected() {
//     // Called when the subscription is ready for use on the server
//   },

//   disconnected() {
//     // Called when the subscription has been terminated by the server
//   },

//   received(data) {
//     // Called when there's incoming data on the websocket for this channel
//   }
// });
