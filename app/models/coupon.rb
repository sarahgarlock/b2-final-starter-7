class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: [:active, :inactive]
  enum amount_type: [:percent, :dollar]

  def self.coupon_code_exists?(code)
    exists?(code: code)
  end
end
