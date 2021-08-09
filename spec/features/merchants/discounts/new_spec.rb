require 'rails_helper'
RSpec.describe 'New Discount' do
  it 'has link to create new bulk discount' do
    merchant = create(:merchant)
    visit merchant_discounts_path(merchant)

    expect(page).to have_link('Create New Discount')
    click_link 'Create New Discount'
    expect(current_path).to eq(new_merchant_discount_path(merchant))
  end
end
