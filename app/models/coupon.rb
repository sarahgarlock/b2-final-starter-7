class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :invoices

  # validates_presence_of :name, :code, :percent_off
end