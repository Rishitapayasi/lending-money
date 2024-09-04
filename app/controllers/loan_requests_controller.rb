class LoanRequestsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_loan_request, only: [:approve, :reject, :adjust, :repay, :show]
  before_action :check_admin, except: [:create, :new, :show, :repay]

  def show
  end

  def new
    @loan_request = LoanRequest.new
  end

  def create
    @loan_request = current_user.loan_requests.new(loan_request_params)
    if @loan_request.save
      redirect_to dashboard_path, notice: 'Loan request created successfully.'
    else
      render :new
    end
  end

  def approve
    @loan_request.update(state: 'approved') if current_user.wallet_balance > @loan_request.amount
    send_push_notification(@loan_request.user, 'Loan request approved', 'Your loan request has been approved.')
    update_wallet_balance
    redirect_to dashboard_path, notice: 'Loan request approved.'
  end

  def reject
    @loan_request.update(state: 'rejected')
    send_push_notification(@loan_request.user, 'Loan request rejected', 'Your loan request has been rejected.')
    redirect_to dashboard_path, notice: 'Loan request rejected.'
  end

  def adjust
    if @loan_request.update(loan_request_params)
      @loan_request.update(state: "waiting_for_adjustment_acceptance")
      send_push_notification(@loan_request.user, 'Loan request adjustment needed', 'Your loan request requires adjustment.')
      redirect_to dashboard_path, notice: 'Loan request adjusted successfully.'
    else
      render :edit, alert: 'Failed to adjust loan request.'
    end
  end

  def repay
    pay_amount = params['loan_request']['amount'].to_i
    admin_wallet = User.admin.wallet_balance
    user_wallet = current_user.wallet_balance
    if user_wallet > @loan_request.total_amount
      User.admin.update(wallet_balance: admin_wallet + pay_amount)
      current_user.update(wallet_balance: user_wallet - pay_amount)
      redirect_to dashboard_path, notice: 'Repayment successfull'
    else
      redirect_to dashboard_path
    end
  end

  private

  def set_loan_request
    @loan_request = LoanRequest.find(params[:id])
  end

  def update_wallet_balance
    loan_user = @loan_request.user
    current_user.update(wallet_balance: current_user.wallet_balance - @loan_request.amount)
    loan_user.update(wallet_balance: loan_user.wallet_balance + @loan_request.amount)
  end

  def check_admin
    render json: {msg: "you are not authorize to perform this action"} unless current_user.is_admin
  end

  def loan_request_params
    params.permit(:amount, :rate_of_interest)
  end

  def send_push_notification(token, title, body)
    options = {
      notification: {
        title: title,
        body: body
      },
      token: token
    }

    response = FCM_CLIENT.send(options)
    Rails.logger.info("Successfully sent message: #{response}")
  end
end
