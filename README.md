# ItBit

[ItBit](https://www.itbit.com) API Client library.

Does some minimal type de-serializations from stringified numbers into
BigDecimals, camelcased strings into underscored symbols, and times into integer
timestamps.


## Installation

Add this line to your application's Gemfile:

    gem 'itbit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install itbit


## Use Public Market Data

Itbit::XBTUSDMarketData, Itbit::XBTSGDMarketData, Itbit::XBTEURMarketData classes have methods for
fetching all public market data available.

### Ticker

    ruby > Itbit::XBTUSDMarketData.ticker
    => {ask: 641.29,
        ask_amt: 0.5,
        bid: 622,
        bid_amt: 0.0006,
        high24h: 618.00000000,
        high_today: 618.00000000,
        last_amt: 0.00040000,
        last_price: 618.00000000,
        low24h: 618.00000000,
        low_today: 618.00000000,
        open_today: 618.00000000,
        pair: symbol.to_s.upcase,
        servertime_utc: 2014-06-24 20:42:35,
        volume24h: 0.00040000,
        volume_today: 0.00040000,
        vwap24h: 618.00000000,
        vwap_today: 618.00000000
       }

### Order Book

    ruby > Itbit::XBTUSDMarketData.orders
    => {bids: [[632.0, 38.910443037975], [630.87, 1.8], ...],
        asks: [[634.9, 0.95], [648.0, 0.4809267], ...]}

### Trades

    ruby > Itbit::XBTUSDMarketData.transactions
    => [ {date: unix_timestamp, price: 123.5, amount: 1.97, tid: 98375},
         {date: unix_timestamp, price: 123.5, amount: 1.97, tid: 98376},
         ...]

## Use for Private Trading

### Authentication and default wallet
You should request your credentials to api@itbit.com, once you've got them
you can configure the gem like this:

    Itbit.client_key = 'your_client_key'
    Itbit.secret = 'your_secret_key'
    Itbit.user_id = 'your_user_id'

You can point the gem to itbit's sandbox like this:

    Itbit.sandbox = true

Itbit gives you more than one 'wallet', which is a set of btc, usd, eur and sgd
balances to use. Most of the time you'll probably end up using just one wallet,
which can be configured like this:

    Itbit.default_wallet_id = 'the-wallet-id-you-want-to-use'

All api calls that need a wallet accept one as an optional argument as well.

### Get your wallets

    ruby > Itbit::Wallet.all
    => { id: "3F2504E0-4F89-41D3-9A0C-0305E82C3301",
         name: "Wallet",
         balances: [
           { total_balance: "20.0".to_d,
             currency: :usd,
             available_balance: "10.0".to_d
           },
           { total_balance: "0.0".to_d,
             currency: :xbt,
             available_balance: "0.0".to_d
           },
           { total_balance: "0.0".to_d,
             currency: :eur,
             available_balance: "0.0".to_d
           },
           { total_balance: "0.0".to_d,
             currency: :sgd,
             available_balance: "0.0".to_d
           }
         ]
       }

### Create a new wallet

    ruby > Itbit::Wallet.create!('wallet_name')

### Place Bids and Asks
You can also pass in a has of keyword arguments at the end, for 
sending metadata and your own order identifiers (which must be unique)
Check the spec/order_spec.rb for more examples.

    ruby > Itbit::Order.create!(:buy, :xbtusd, 1.5, 500.0)
    ruby > Itbit::Order.create!(:sell, :xbtsgd, 1.5, 500.0)

### List your pending or recently active orders
Orders can also be filtered and paginated by passing in keyword arguments,
Check spec/order_spec.rb for more examples.

    ruby > Itbit::Order.all

### Find an order

    ruby > Itbit::Order.find('some-order-id')

### Cancel an order

    ruby > Itbit::Order.find('some-order-id').cancel!

### List your trades
Trades can also be filtered by date and paginated by passing in keyword arguments,
Check spec/trade_spec.rb for more examples.

    ruby > Itbit::Trade.all

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
