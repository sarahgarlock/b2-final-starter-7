class RemoveStatusFromCoupons < ActiveRecord::Migration[7.0]
  def change
    remove_column :coupons, :status, :integer
  end
end
