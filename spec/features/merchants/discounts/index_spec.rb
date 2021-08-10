require 'rails_helper'
RSpec.describe 'Discount Index page' do
  it 'can list bulk discounts and attributes' do
    merchant = create(:merchant)
    discount1 = merchant.discounts.create!(percentage_discount: 25, quantity_threshold: 45)
    discount2 = merchant.discounts.create!(percentage_discount: 10, quantity_threshold: 30)
    discount3 = merchant.discounts.create!(percentage_discount: 50, quantity_threshold: 60)

    visit merchant_discounts_path(merchant)

    expect(page).to have_content(discount1.percentage_discount)
    expect(page).to have_content(discount1.quantity_threshold)
  end
end
