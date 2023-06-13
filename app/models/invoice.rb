class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  belongs_to :coupon, optional: true

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def total_revenue_after_discount
    total_rev = invoice_items.sum("unit_price * quantity")
    return total_rev unless coupon.present?
  
    if coupon.amount_type == "percent"
      total_rev -= total_rev * (coupon.value.to_f / 100)
    else
      new_total_rev = total_rev - coupon.value
      new_total_rev = 0 if new_total_rev < 0
      total_rev = new_total_rev
    end
    total_rev
  end
end
