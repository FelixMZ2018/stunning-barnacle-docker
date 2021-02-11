# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table :messages, id: :uuid do |t|
      t.string :content, null: false, limit: 255
      t.timestamps
    end
  end
end
