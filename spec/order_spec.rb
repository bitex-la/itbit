require 'spec_helper'

describe Itbit::Order do
  it 'lists all' do
    stub_get("/wallets/wallet-000/orders", 'orders')
    orders = Itbit::Order.all
    orders.size.should == 2
    orders.each{|o| o.should be_an Itbit::Order}
    orders.first.side.should == :buy
    orders.last.side.should == :sell
  end

  it 'Accepts filtering by instrument, status and pagination' do
    stub_get("/wallets/wallet-001/orders", 'orders',
      instrument: 'XBTUSD',
      status: 'open',
      page: '1',
      perPage: '200')
    orders = Itbit::Order.all(
      wallet_id: 'wallet-001',
      instrument: :xbtusd,
      status: :open,
      page: 1,
      per_page: 200)
    orders.size.should == 2
  end
  
  it 'Finds an order' do
    stub_get("/wallets/wallet-000/orders/8fd820d3-baff-4d6f-9439-ff03d816c7ce", 'order')
    order = Itbit::Order.find("8fd820d3-baff-4d6f-9439-ff03d816c7ce")
    order.should be_an Itbit::Order
    order.id.should == "8fd820d3-baff-4d6f-9439-ff03d816c7ce"
  end
  
  it 'Places an order' do
    stub_post("/wallets/wallet-000/orders", 'order',
      side: 'buy',
      instrument: 'XBTUSD',
      amount: '1.0005',
      price: '100.0',
      type: 'limit',
      currency: 'XBT'
    )
    order = Itbit::Order.create!(:buy, :xbtusd, 1.0005, 100.0)
    order.should be_an Itbit::Order
    order.status.should == :submitted
  end

  it 'Places an order with optional arguments' do
    stub_post("/wallets/wallet-000/orders", 'order', {
      side: 'buy',
      instrument: 'XBTUSD',
      amount: '1.0005',
      price: '100.0',
      type: 'limit',
      currency: 'XBT',
      metadata: {"foo" => "bar"},
      clientOrderIdentifier: 'unique_yet_optional'
    })
    order = Itbit::Order.create!(:buy, :xbtusd, 1.0005, 100.0,
      type: :limit,
      metadata: {"foo" => "bar"},
      client_order_identifier: 'unique_yet_optional')
    order.should be_an Itbit::Order
    order.status.should == :submitted
  end

  it 'places for btc and waits until processed by the matching engine' do
    stub_post("/wallets/wallet-000/orders", 'order',
      side: 'buy',
      instrument: 'XBTUSD',
      amount: '1.0005',
      price: '100.0',
      type: 'limit',
      currency: 'XBT'
    )
    stub_get("/wallets/wallet-000/orders/8fd820d3-baff-4d6f-9439-ff03d816c7ce",
      'open_order')
    order = Itbit::Order.create!(:buy, :xbtusd, 1.0005, 100.0, wait: true)
    order.should be_an Itbit::Order
    order.status.should == :open
  end
  
  it 'cancels one' do
    url = "/wallets/wallet-000/orders/8fd820d3-baff-4d6f-9439-ff03d816c7ce"
    stub_delete(url, nil)
    stub_get(url, 'open_order')
    order = Itbit::Order.find("8fd820d3-baff-4d6f-9439-ff03d816c7ce")
    order.cancel!
    order.status.should == :cancelling
  end
end
