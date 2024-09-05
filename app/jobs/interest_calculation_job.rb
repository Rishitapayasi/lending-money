class InterestCalculationJob < ApplicationJob

  queue_as :default

  def perform
    LoanRequest.state_approved.find_each do |loan_request|
      next if loan_request.repaid?
      LoanInterestService.new(loan_request).call
    end
  end
end