# frozen_string_literal: true
class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.text :original_text
      t.text :translated_text
      t.date :review_date
      t.integer :block_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
