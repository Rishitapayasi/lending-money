class CreateLoanRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :loan_requests do |t|
      t.integer :amount
      t.decimal :rate_of_interest
      t.integer :state, default: 0, null: false
      t.references :user

      t.timestamps
    end
  end
end
