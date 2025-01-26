class CreateSearchRecipes < ActiveRecord::Migration[7.2]
  def change
    create_table :search_recipes do |t|
      t.references :user, foreign_key: true, null: true
      t.string :query, null: false
      t.datetime :search_time, null: false
      t.json :response_data

      t.timestamps
    end
  end
end
