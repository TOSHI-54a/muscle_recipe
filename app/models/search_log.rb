class SearchLog < ApplicationRecord
    belongs_to :user, optional: true

    validates :search_time, presence: true
    validates :user_id, uniqueness: { scope: :search_time, message: "Search already logged for today" }, if: -> { user_id.present? }
end
