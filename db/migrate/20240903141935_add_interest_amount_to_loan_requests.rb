class AddInterestAmountToLoanRequests < ActiveRecord::Migration[7.1]
  def change
    add_column :loan_requests, :interest_amount, :integer, default: 0
  end
end
