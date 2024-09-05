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
    service = LoanRequestService.new(@loan_request, current_user)
    if service.approve
      redirect_to dashboard_path, notice: 'Loan request approved.'
    else
      redirect_to dashboard_path, alert: 'Loan approval failed.'
    end
  end

  def reject
    service = LoanRequestService.new(@loan_request, current_user)
    if service.reject
      redirect_to dashboard_path, notice: 'Loan request rejected.'
    else
      redirect_to dashboard_path, alert: 'Loan rejection failed.'
    end
  end

  def adjust
    service = LoanRequestService.new(@loan_request, current_user)
    if service.adjust(loan_request_params)
      redirect_to dashboard_path, notice: 'Loan request adjusted successfully.'
    else
      redirect_to dashboard_path, alert: 'Failed to adjust loan request.'
    end
  end

  def repay
    pay_amount = params['loan_request']['amount'].to_i
    service = LoanRequestService.new(@loan_request, current_user)
    if service.repay(pay_amount)
      redirect_to dashboard_path, notice: 'Repayment successful.'
    else
      redirect_to dashboard_path, alert: 'Repayment failed.'
    end
  end

  private

  def set_loan_request
    @loan_request = LoanRequest.find(params[:id])
  end

  def check_admin
    render json: {msg: "You are not authorized to perform this action"} unless current_user.is_admin
  end

  def loan_request_params
    params.permit(:amount, :rate_of_interest)
  end
end
