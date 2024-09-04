class UsersController < ApplicationController

	def dashboard
		if current_user.is_admin
      @loan_requests = LoanRequest.all
    else
    	@loan_requests = current_user.loan_requests
		end
	end

	def index
	end

	def show
	end
end