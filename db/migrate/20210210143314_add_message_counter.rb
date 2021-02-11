class AddMessageCounter < ActiveRecord::Migration[6.1]
  def change
    add_column :messages, :counter, :integer, default: 0

  end
end
