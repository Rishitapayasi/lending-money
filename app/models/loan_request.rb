class LoanRequest < ApplicationRecord
	belongs_to :user

	enum state: %i[ requested approved processing closed rejected waiting_for_adjustment_acceptance readjustment_requested ], _prefix: true

  def total_amount
    amount + interest_amount
  end

  def repaid?
    state == 'closed'
  end
end
