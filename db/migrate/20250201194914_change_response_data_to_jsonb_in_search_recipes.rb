class ChangeResponseDataToJsonbInSearchRecipes < ActiveRecord::Migration[7.2]
  def change
    change_column :search_recipes, :response_data, :jsonb, using: 'response_data::jsonb'
  end
end
