require 'rails_helper'
RSpec.describe 'delete discount' do
  it 'has a link to delete' do
    merchant = create(:merchant)
    discount1 = merchant.discounts.create!(percentage_discount: 25, quantity_threshold: 45)
    discount2 = merchant.discounts.create!(percentage_discount: 10, quantity_threshold: 30)
    discount3 = merchant.discounts.create!(percentage_discount: 50, quantity_threshold: 60)
    visit merchant_discounts_path(merchant)

    expect(page).to have_link('Delete Discount')
  end

  it 'can delete discount' do
    merchant = create(:merchant)
    discount1 = merchant.discounts.create!(percentage_discount: 25, quantity_threshold: 45)
    discount2 = merchant.discounts.create!(percentage_discount: 10, quantity_threshold: 30)
    discount3 = merchant.discounts.create!(percentage_discount: 50, quantity_threshold: 60)
    visit merchant_discounts_path(merchant)
    within ("#discount-#{discount3.id}") do
      click_link 'Delete Discount'
    end
    expect(current_path).to eq(merchant_discounts_path(merchant))
    expect(page).to_not have_content("Quantity Threshold: #{discount3.quantity_threshold}")
    expect(page).to_not have_content("Percentage Discount: #{discount3.percentage_discount}")
  end
end
