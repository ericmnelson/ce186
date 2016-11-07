require 'rails_helper'
require 'utils'

RSpec.describe Charge, type: :model do
  before :each do
    @charge_round = Charge.create!(:amount => 1100)
    @charge_decimal = Charge.create!(:amount => 1100.30)
  end
  describe 'getting the amount' do
    it 'should get the correctly formatted default amount' do
      expect(@charge_round.amount_formatted).to eq("$1,100.00")
      expect(@charge_decimal.amount_formatted).to eq("$1,100.30")
    end
    it 'should get the correctly formatted plain default amount' do
      expect(@charge_round.amount_formatted_plain).to eq("1,100.00")
      expect(@charge_decimal.amount_formatted_plain).to eq("1,100.30")
    end
    it 'should get the correctly formatted slim amount (for SMS)' do
      expect(@charge_round.amount_formatted_slim).to eq("$1,100")
      expect(@charge_decimal.amount_formatted_slim).to eq("$1,100.30")
    end
    it 'should get the correctly formatted amount with decimal' do
      expect(@charge_round.amount_formatted_with_decimal).to eq("$1,100.00")
      expect(@charge_decimal.amount_formatted_with_decimal).to eq("$1,100.30")
    end
    it 'should get the correctly formatted amount without decimal' do
      expect(@charge_round.amount_formatted_without_decimal).to eq("$1,100")
      expect(@charge_decimal.amount_formatted_without_decimal).to eq("$1,100")
    end
  end
end  
 