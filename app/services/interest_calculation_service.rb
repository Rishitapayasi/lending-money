class LoanInterestService

  def initialize(loan_request)
    @loan_request = loan_request
    @user = loan_request.user
  end

  def call
    calculate_interest
  end

  private

  def calculate_interest
    if @user.wallet_balance >= @loan_request.total_amount
      add_interest
    else
      recover_loan_amount
    end
  end


  def add_interest
    principal = @loan_request.amount
    rate = @loan_request.rate_of_interest / 100.0
    time_period = 5.minutes / 60.0
    interest = (principal * rate * time_period).round(2)

    @loan_request.update(interest_amount: @loan_request.interest_amount + interest)
  end

  def recover_loan_amount
    user_balance = @user.wallet_balance
    admin_balance = User.admin.wallet_balance + user_balance
    User.admin.update(wallet_balance: admin_balance)
    @user.update(wallet_balance: 0)
    @loan_request.update(state: 'closed')
  end
end
