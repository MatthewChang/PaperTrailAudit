class AddUserIdToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :user_id, :integer
  end
end
