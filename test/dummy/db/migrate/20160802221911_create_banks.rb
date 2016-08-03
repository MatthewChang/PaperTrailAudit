class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :value
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
