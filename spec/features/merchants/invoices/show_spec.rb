require 'rails_helper'

RSpec.describe 'Merchants invoices show page' do
  describe "invoices" do
    before(:each) do
      @merchant_1 = create(:merchant)

      @customers = []
      @invoices = []
      @items = []
      @transactions = []
      @invoice_items = []

      5.times do
        @customers << create(:customer)
        @invoices << create(:invoice, customer_id: @customers.last.id, created_at: DateTime.new(2020,2,3,4,5,6))
        @items << create(:item, merchant_id: @merchant_1.id, unit_price: 20)
        @transactions << create(:transaction, invoice_id: @invoices.last.id)
        @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices.last.id, status: 1, quantity: 10, unit_price: @items.last.unit_price)
      end

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}"
    end

    it "has path to page" do
      expect(page).to have_content("Invoice ##{@invoices[0].id}")
    end

    it "shows correct date format created at" do
      expect(page).to have_content("Monday February 3, 2020")
    end

    it "has all attributes" do
      expect(page).to have_content("#{@invoices[0].status}")
      expect(page).to have_content("#{@invoices[0].id}")
      expect(page).to have_content("Monday February 3, 2020")
      expect(page).to have_content("#{@customers[0].first_name}")
      expect(page).to have_content("#{@customers[0].last_name}")
    end

    it "can list total revenue" do
      @items << create(:item, merchant_id: @merchant_1.id, unit_price: 1598)
      @invoice_items << create(:invoice_item, item_id: @items.last.id, invoice_id: @invoices[0].id, status: 1, quantity: 10, unit_price: @items.last.unit_price)

      visit "/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}"
      expect(page).to have_content("Total Revenue: $161.80")

    end

    it "allows merchant to select invoice status" do
      expect(@invoice_items[0].status).to eq("packaged")

      page.select "shipped", from: 'status'
      click_button "Update Item Status"

      expect(page).to have_content("shipped")
      expect(current_path).to eq("/merchants/#{@merchant_1.id}/invoices/#{@invoices[0].id}")
    end
  end

  describe 'discount functionality' do
    it 'displays total discounted revenue from all items on invoice' do
      InvoiceItem.destroy_all
      Item.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      Customer.destroy_all
      Merchant.destroy_all

      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, quantity: 10, item: item1, invoice: invoice, status: 1)
      invoice_item1 = create(:invoice_item, quantity: 20, item: item2, invoice: invoice, status: 1)
      discount = merchant.discounts.create!(quantity_threshold: 15, percentage_discount: 10)

      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

      expect(page).to have_content("Revenue after discount was applied: $#{invoice.discounted_total_revenue/100}")
    end

    it 'has link to discount show page' do
      InvoiceItem.destroy_all
      Item.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      Customer.destroy_all
      Merchant.destroy_all

      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, quantity: 10, item: item1, invoice: invoice, status: 1)
      invoice_item1 = create(:invoice_item, quantity: 20, item: item2, invoice: invoice, status: 1)
      discount = merchant.discounts.create!(quantity_threshold: 15, percentage_discount: 10)

      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

      expect(page).to have_link("10.0%")
    end

    it 'can link to invoice show page' do
      InvoiceItem.destroy_all
      Item.destroy_all
      Transaction.destroy_all
      Invoice.destroy_all
      Customer.destroy_all
      Merchant.destroy_all

      merchant = create(:merchant)
      customer = create(:customer)
      invoice = create(:invoice, customer: customer)
      item1 = create(:item, merchant: merchant)
      item2 = create(:item, merchant: merchant)
      invoice_item1 = create(:invoice_item, quantity: 10, item: item1, invoice: invoice, status: 1)
      invoice_item1 = create(:invoice_item, quantity: 20, item: item2, invoice: invoice, status: 1)
      discount = merchant.discounts.create!(quantity_threshold: 15, percentage_discount: 10)

      visit "/merchants/#{merchant.id}/invoices/#{invoice.id}"

      click_link "10.0%"
      expect(current_path).to eq(merchant_discount_path(merchant, discount))
    end
  end
end
