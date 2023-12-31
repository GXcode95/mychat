class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.references :author, null: false, foreign_key: { to_table: :users }
      t.references :room, null: false, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end
