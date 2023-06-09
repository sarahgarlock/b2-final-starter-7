class Coupon < ApplicationRecord
  belongs_to :merchant

  # validates_presence_of :name, :code, :percent_off
end