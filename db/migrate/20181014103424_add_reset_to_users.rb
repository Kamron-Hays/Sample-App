# Created via the command:
# $ rails generate migration add_reset_to_users reset_digest:string reset_sent_at:datetime
class AddResetToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :reset_digest, :string
    add_column :users, :reset_sent_at, :datetime
  end
end
