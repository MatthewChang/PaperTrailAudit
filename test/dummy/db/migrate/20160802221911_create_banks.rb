class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.integer :value
      t.timestamps null: false
    end
  end
end
