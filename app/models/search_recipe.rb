class SearchRecipe < ApplicationRecord
    belongs_to :user, optional: true

    validates :query, presence: true
    validates :search_time, presence: true
end
