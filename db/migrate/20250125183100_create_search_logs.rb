class CreateSearchLogs < ActiveRecord::Migration[7.2]
  def change
    create_table :search_logs do |t|
      t.references :user, foreign_key: true, null: true
      t.string :session_id
      t.string :ip_address
      t.datetime :search_time

      t.timestamps
    end
  end
end
