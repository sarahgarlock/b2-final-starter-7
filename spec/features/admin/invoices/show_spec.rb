require "rails_helper"

describe "Admin Invoices Index Page" do
  before :each do
    @m1 = Merchant.create!(name: "Merchant 1")

    @c1 = Customer.create!(first_name: "Yo", last_name: "Yoz", address: "123 Heyyo", city: "Whoville", state: "CO", zip: 12345)
    @c2 = Customer.create!(first_name: "Hey", last_name: "Heyz")

    @coupon1 = Coupon.create!(name: "10 Percent Off", code: "10%off", value: 10, amount_type: 0, merchant_id: @m1.id) 
    @coupon2 = Coupon.create!(name: "20 Dollars Off", code: "$20off", value: 20, amount_type: 1, merchant_id: @m1.id)
    @coupon3 = Coupon.create!(name: "101 Dollars Off", code: "$101off", value: 101, amount_type: 1, merchant_id: @m1.id)
                                                                      # enum amount_type: [:percent, :dollar]

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: "2012-03-25 09:54:09")
    @i2 = Invoice.create!(customer_id: @c2.id, status: 1, created_at: "2012-03-25 09:30:09")
    @i3 = Invoice.create!(customer_id: @c2.id, status: 0, coupon_id: @coupon1.id, created_at: "2012-03-25 09:30:09")
    @i4 = Invoice.create!(customer_id: @c2.id, status: 0, coupon_id: @coupon2.id, created_at: "2012-03-25 09:30:09")
    @i5 = Invoice.create!(customer_id: @c2.id, status: 0, coupon_id: @coupon3.id, created_at: "2012-03-25 09:30:09")

    @item_1 = Item.create!(name: "test", description: "lalala", unit_price: 6, merchant_id: @m1.id)
    @item_2 = Item.create!(name: "rest", description: "dont test me", unit_price: 12, merchant_id: @m1.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 2, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 1, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 87, unit_price: 12, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_2.id, quantity: 40, unit_price: 12, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_1.id, quantity: 15, unit_price: 12, status: 2)
    @ii_6 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_2.id, quantity: 26, unit_price: 12, status: 2)
    @ii_7 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_1.id, quantity: 33, unit_price: 8, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_1.id, quantity: 10, unit_price: 10, status: 2)

    visit admin_invoice_path(@i1)
  end

  it "should display the id, status and created_at" do
    expect(page).to have_content("Invoice ##{@i1.id}")
    expect(page).to have_content("Created on: #{@i1.created_at.strftime("%A, %B %d, %Y")}")

    expect(page).to_not have_content("Invoice ##{@i2.id}")
  end

  it "should display the customers name and shipping address" do
    expect(page).to have_content("#{@c1.first_name} #{@c1.last_name}")
    expect(page).to have_content(@c1.address)
    expect(page).to have_content("#{@c1.city}, #{@c1.state} #{@c1.zip}")

    expect(page).to_not have_content("#{@c2.first_name} #{@c2.last_name}")
  end

  it "should display all the items on the invoice" do
    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_2.name)

    expect(page).to have_content(@ii_1.quantity)
    expect(page).to have_content(@ii_2.quantity)

    expect(page).to have_content("$#{@ii_1.unit_price}")
    expect(page).to have_content("$#{@ii_2.unit_price}")

    expect(page).to have_content(@ii_1.status)
    expect(page).to have_content(@ii_2.status)

    expect(page).to_not have_content(@ii_3.quantity)
    expect(page).to_not have_content("$#{@ii_3.unit_price}")
    expect(page).to_not have_content(@ii_3.status)
  end

  it "should display the total revenue the invoice will generate" do
    expect(page).to have_content("Total Revenue: $#{@i1.total_revenue}")

    expect(page).to_not have_content(@i2.total_revenue)
  end

  it "should have status as a select field that updates the invoices status" do
    within("#status-update-#{@i1.id}") do
      select("cancelled", :from => "invoice[status]")
      expect(page).to have_button("Update Invoice")
      click_button "Update Invoice"

      expect(current_path).to eq(admin_invoice_path(@i1))
      expect(@i1.status).to eq("completed")
    end
  end

  it 'displays the name and code of the coupon that was used for percent off coupons' do
    visit admin_invoice_path(@i3)

    expect(page).to have_content("#{@coupon1.name}")
    expect(page).to have_content("#{@coupon1.code}")
    expect(page).to have_content("Grand Total Revenue After Discount: $594.00")
  end

  it 'displays the name and code of the coupon that was used for dollar off coupons' do
    visit admin_invoice_path(@i4)

    expect(page).to have_content("#{@coupon2.name}")
    expect(page).to have_content("#{@coupon2.code}")
    expect(page).to have_content("Grand Total Revenue After Discount: $556.00")
  end

  it 'will not display a negative number for a dollar coupon amount larger than total amount' do
    visit admin_invoice_path(@i5)
    
    expect(page).to have_content("Total Revenue: $100.00")
    expect(page).to have_content("Grand Total Revenue After Discount: $0.00")
    expect(page).to_not have_content("Grand Total Revenue After Discount: -$1.00")
  end
end
