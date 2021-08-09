require 'rails_helper'
RSpec.describe 'Discounts show page' do
  it 'displays discount attributes' do
    merchant = create(:merchant)
    discount = merchant.discounts.create(percentage_discount: 20, quantity_threshold: 40)

    visit merchant_discount_path(merchant, discount)

    expect(page).to have_content(discount.percentage_discount)
    expect(page).to have_content(discount.quantity_threshold)
  end
end
