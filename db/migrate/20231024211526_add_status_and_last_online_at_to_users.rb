class AddStatusAndLastOnlineAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :status, :integer, default: 0, null: false
    add_column :users, :last_online_at, :datetime
  end
end
