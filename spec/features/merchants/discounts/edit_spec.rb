require 'rails_helper'
RSpec.describe 'Edit discounts' do
  it 'has fields filled out with previous information' do
    merchant = create(:merchant)
    discount = merchant.discounts.create(percentage_discount: 20, quantity_threshold: 40)
    visit edit_merchant_discount_path(merchant, discount)

    expect(page).to have_field("discount_quantity_threshold", with: 40)
    expect(page).to have_field("discount_percentage_discount", with: '20.0')
  end

  it 'can submit new information and update page' do
    merchant = create(:merchant)
    discount = merchant.discounts.create(percentage_discount: 20, quantity_threshold: 40)
    visit edit_merchant_discount_path(merchant, discount)

    fill_in "discount_quantity_threshold", with: 60
    fill_in "discount_percentage_discount", with: '15.0'
    click_button 'Update Discount'

    expect(current_path).to eq(merchant_discount_path(merchant, discount))
    expect(page).to have_content(60)
    expect(page).to have_content('15.0%')
  end
end
