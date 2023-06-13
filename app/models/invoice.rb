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
    if coupon.present?
      if coupon.amount_type == "percent"
        total_rev - (total_rev * (coupon.value.to_f / 100))
      else
        total_rev - coupon.value
      end
    end
  end
end
