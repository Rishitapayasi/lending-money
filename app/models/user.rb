class User < ApplicationRecord
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

	before_create :set_wallet_default_amount

	has_many :loan_requests

	validates :is_admin, uniqueness: true, if: -> { is_admin }
	validates :phone_number, length: { maximum: 10 }
  
  scope :admin, -> { find_by(is_admin: true) }

  private

  def set_wallet_default_amount
    is_admin ? self.wallet_balance = 100000 : self.wallet_balance = 10000
  end
end