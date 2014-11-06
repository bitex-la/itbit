require 'spec_helper'

describe Itbit::Trade do
  it 'lists all' do
    stub_get("/wallets/wallet-000/trades", 'user_trades')
    trades = Itbit::Trade.all
    trades[:trading_history].size.should == 2
    trades[:trading_history].each{|o| o.should be_an Itbit::Trade}
    trades[:trading_history].first.tap do |trade|
      trade.order_id.should == "c78363f9-1169-4dbb-b256-0756880dc625"
      trade.direction.should == :buy
      trade.commission_paid.should == "0.40250000".to_d
      trade.timestamp.should == Time.parse("2014-03-04T16:02:28.0070000Z").to_i
      trade.rebates_applied.should == 0
      trade.currency2.should == :usd
      trade.instrument.should == :xbtusd
      trade.rate.should == "575.00000000".to_d
      trade.currency1.should == :xbt
      trade.rebate_currency.should == :usd
      trade.currency1_amount.should == "0.10000000".to_d
      trade.currency2_amount.should == "57.5000000000000000".to_d
      trade.commission_currency.should == :usd
    end
  end

  it 'Accepts filtering by instrument, status and pagination' do
    stub_get("/wallets/wallet-001/trades", 'user_trades',
      rangeStart: 0,
      rangeEnd: 100000,
      page: '1',
      perPage: '200')
    trades = Itbit::Trade.all(
      wallet_id: 'wallet-001',
      range_start: 0,
      range_end: 100000,
      page: 1,
      per_page: 200)
    trades[:trading_history].size.should == 2
    trades[:trading_history].each{|o| o.should be_an Itbit::Trade}
  end
end
