class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :phone_number
      t.string :occupation
      t.boolean :is_admin, default: false
      t.integer :wallet_balance

      t.timestamps
    end
  end
end
