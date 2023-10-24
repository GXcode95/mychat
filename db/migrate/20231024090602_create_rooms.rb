class CreateRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.boolean :is_private, default: false, null: false

      t.timestamps
    end

    add_index :rooms, :name, unique: true
  end
end