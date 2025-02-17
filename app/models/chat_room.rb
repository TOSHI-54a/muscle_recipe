class ChatRoom < ApplicationRecord
    has_many :chat_room_users
    has_many :users, through: :chat_room_users, dependent: :destroy
    has_many :messages, dependent: :destroy

    validates :room_type, inclusion: { in: %w[private group] }
    validates :name, presence: true, if: -> { room_type == "group" }

    def other_user(current_user)
        users.where.not(id: current_user.id).first
    end

    def other_users(chat_room)
        chat_room.users.where.not(id: current_user.id)
    end
end
