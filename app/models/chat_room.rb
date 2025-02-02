class ChatRoom < ApplicationRecord
    has_many :chat_room_users
    has_many :users, through: :chat_room_users
    has_many :messages

    validates :room_type, inclusion: { in: %w[private group] }
end
