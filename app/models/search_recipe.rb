class SearchRecipe < ApplicationRecord
    belongs_to :user, optional: true

    validates :query, presence: true
    validates :search_time, presence: true

    def parsed_response_data
        response_data.is_a?(String) ? JSON.parse(response_data) : response_data
    end
end
