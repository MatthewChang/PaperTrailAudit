class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :state
      t.timestamps null: false
    end
  end
end
