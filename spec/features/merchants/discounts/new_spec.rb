require 'rails_helper'
RSpec.describe 'New Discount' do
  it 'has link to create new bulk discount' do
    merchant = create(:merchant)
    visit merchant_discounts_path(merchant)

    expect(page).to have_link('Create New Discount')
    click_link 'Create New Discount'
    expect(current_path).to eq(new_merchant_discount_path(merchant))
  end

  it 'has form and redirects to index page' do
    merchant = create(:merchant)
    visit merchant_discounts_path(merchant)

    click_link 'Create New Discount'
    fill_in "discount_quantity_threshold", with: 15
    fill_in "discount_percentage_discount", with: 10.5
    click_button('Create New Discount')
    expect(current_path).to eq(merchant_discounts_path(merchant))
    expect(page).to have_content(15)
    expect(page).to have_content('10.5%')
  end
end
