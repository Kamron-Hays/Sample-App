# Created via rails generate migration add_password_digest_to_users password_digest:string
class AddPasswordDigestToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_digest, :string
  end
end
