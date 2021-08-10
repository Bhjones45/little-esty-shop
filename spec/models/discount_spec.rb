require 'rails_helper'
RSpec.describe Discount do

  describe 'relationships' do
    it { should belong_to(:merchant) }
  end

  describe 'class methods' do
    describe 'highest discount' do
      it 'can returns the highest available discount' do
        merchant = create(:merchant)
        discount1 = merchant.discounts.create(quantity_threshold: 5, percentage_discount: 10)
        discount2 = merchant.discounts.create(quantity_threshold: 10, percentage_discount: 15)
        discount3 = merchant.discounts.create(quantity_threshold: 15, percentage_discount: 20)

        expect(Discount.highest_discount(1)).to eq(nil)
        expect(Discount.highest_discount(7)).to eq(discount1)
        expect(Discount.highest_discount(12)).to eq(discount2)
        expect(Discount.highest_discount(18)).to eq(discount3)
      end
    end
  end
end
