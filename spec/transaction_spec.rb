require 'spec_helper'

describe Itbit::Transaction do
  it 'gets all transactions' do
    stub_private(:get, "/private/transactions", 'user_transactions')
    buy, sell, specie_deposit, specie_withdrawal, usd_deposit, usd_withdrawal =
      Itbit::Transaction.all
    buy.should be_a Itbit::Buy
    sell.should be_a Itbit::Sell
    specie_deposit.should be_a Itbit::SpecieDeposit
    specie_withdrawal.should be_a Itbit::SpecieWithdrawal
    usd_deposit.should be_a Itbit::UsdDeposit
    usd_withdrawal.should be_a Itbit::UsdWithdrawal
  end
end
