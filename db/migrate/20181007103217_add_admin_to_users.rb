# Created via rails generate migration add_admin_to_users admin:boolean
#
# Manually added "default: false", which means that users will not be
# administrators by default. Without the default: false argument, admin
# will be nil by default, which is still false, so this step is not strictly
# necessary. It is more explicit, though, and communicates intentions more
# clearly.
class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
