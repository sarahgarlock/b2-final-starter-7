class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  enum status: [:active, :inactive]
  enum amount_type: [:percent, :dollar]
end
