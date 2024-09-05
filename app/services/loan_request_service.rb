class LoanRequestService

  def initialize(loan_request, current_user)
    @loan_request = loan_request
    @current_user = current_user
  end

  def approve
    if @current_user.wallet_balance > @loan_request.amount
      @loan_request.update(state: 'approved')
      update_wallet_balance
      send_push_notification(@loan_request.user, 'Loan request approved', 'Your loan request has been approved.')
    else
      raise StandardError, 'Insufficient wallet balance to approve loan.'
    end
  rescue => e
    Rails.logger.error("Failed to approve loan request: #{e.message}")
    false
  end

  def reject
    @loan_request.update(state: 'rejected')
    send_push_notification(@loan_request.user, 'Loan request rejected', 'Your loan request has been rejected.')
  rescue => e
    Rails.logger.error("Failed to reject loan request: #{e.message}")
    false
  end

  def adjust(loan_params)
    if @loan_request.update(loan_params)
      @loan_request.update(state: "waiting_for_adjustment_acceptance")
      send_push_notification(@loan_request.user, 'Loan request adjustment needed', 'Your loan request requires adjustment.')
    else
      raise StandardError, 'Failed to update loan request.'
    end
  rescue => e
    Rails.logger.error("Failed to adjust loan request: #{e.message}")
    false
  end

  def repay(pay_amount)
    admin_wallet = User.admin.wallet_balance
    user_wallet = @current_user.wallet_balance
    total_amount = @loan_request.total_amount

    if user_wallet >= total_amount
      User.admin.update(wallet_balance: admin_wallet + pay_amount)
      @current_user.update(wallet_balance: user_wallet - pay_amount)
    else
      raise StandardError, 'Insufficient wallet balance for repayment.'
    end
  rescue => e
    Rails.logger.error("Repayment failed: #{e.message}")
    false
  end

  private

  def update_wallet_balance
    loan_user = @loan_request.user
    @current_user.update(wallet_balance: @current_user.wallet_balance - @loan_request.amount)
    loan_user.update(wallet_balance: loan_user.wallet_balance + @loan_request.amount)
  end

  def send_push_notification(user, title, body)
    options = {
      notification: {
        title: title,
        body: body
      },
      token: user
    }

    response = FCM_CLIENT.send(options)
    Rails.logger.info("Successfully sent message: #{response}")
  rescue => e
    Rails.logger.error("Failed to send push notification: #{e.message}")
  end
end
