class InterestCalculationJob < ApplicationJob

  queue_as :default

  def perform
    LoanRequest.state_approved.find_each do |loan_request|
      next if loan_request.repaid?
      
      if loan_request.user.wallet_balance >= loan_request.total_amount
        principal = loan_request.amount
        rate = loan_request.rate_of_interest / 100.0
        time_period = 5.minutes / 60.0
        interest = (principal * rate * time_period).round(2)

        loan_request.update(interest_amount: loan_request.interest_amount + interest)
      else
        user_balance = loan_request.user.wallet_balance
        admin_balance = User.admin.wallet_balance + user_balance
        User.admin.update(wallet_balance: admin_balance)
        loan_request.user.update(wallet_balance: 0)
        loan_request.update(state: 'closed')
      end
    end
  end
end