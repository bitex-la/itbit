require 'spec_helper'

describe Itbit::SpecieWithdrawal do
  let(:as_json) do
    [6,12345678,946685400,1,100.00000000,1,0, '1helloworld', 'label', 1]
  end

  it_behaves_like 'API class'
  it_behaves_like 'API class with a specie'

  it "sets quantity as BigDecimal" do
    thing = Itbit::SpecieWithdrawal.from_json(as_json).quantity
    thing.should be_a BigDecimal
    thing.should == 100.0
  end

  { 1 => :received,
    2 => :pending,
    3 => :done,
    4 => :cancelled,
  }.each do |code, symbol|
    it "sets status #{code} to #{symbol}" do
      as_json[5] = code
      Itbit::SpecieWithdrawal.from_json(as_json).status.should == symbol
    end
  end

  { 0 => :not_cancelled,
    1 => :insufficient_funds,
    2 => :destination_invalid,
  }.each do |code, symbol|
    it "sets reason #{code} to #{symbol}" do
      as_json[6] = code
      Itbit::SpecieWithdrawal.from_json(as_json).reason.should == symbol
    end
  end

  it "sets label" do
    thing = Itbit::SpecieWithdrawal.from_json(as_json).label
    thing.should == 'label'
  end

  it "sets to_address" do
    thing = Itbit::SpecieWithdrawal.from_json(as_json).to_address
    thing.should == "1helloworld"
  end

  it "sets the kyc profile id" do
    Itbit::SpecieWithdrawal.from_json(as_json).kyc_profile_id.should == 1
  end

  it 'creates a new withdrawal' do
    stub_private(:post, "/private/ltc/withdrawals", 'specie_withdrawal', {
      address: '1ADDR',
      amount: 110,
      label: 'thelabel',
    })
    deposit = Itbit::SpecieWithdrawal.create!(:ltc, '1ADDR', 110, 'thelabel')
    deposit.should be_a Itbit::SpecieWithdrawal
    deposit.status.should == :received
  end
  
  it 'finds a single usd deposit' do
    stub_private(:get, '/private/btc/withdrawals/1', 'specie_withdrawal')
    deposit = Itbit::SpecieWithdrawal.find(:btc, 1)
    deposit.should be_a Itbit::SpecieWithdrawal
    deposit.status.should == :received
  end
  
  it 'lists all usd deposits' do
    stub_private(:get, '/private/btc/withdrawals', 'specie_withdrawals')
    deposits = Itbit::SpecieWithdrawal.all(:btc)
    deposits.should be_an Array
    deposits.first.should be_an Itbit::SpecieWithdrawal
    deposits.first.status.should == :received
  end
end
