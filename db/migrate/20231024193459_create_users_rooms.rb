class CreateUsersRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :users_rooms do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.integer :role, null: false
      t.integer :status, null: false

      t.timestamps
    end
  end
end
