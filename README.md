# ItBit

[ItBit](https://www.itbit.com) API Client library.


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
    => {
        :ask => 641.29,
        :askAmt => 0.5,
        :bid => 622,
        :bidAmt => 0.0006,
        :high24h => 618.00000000,
        :highToday => 618.00000000,
        :lastAmt => 0.00040000,
        :lastPrice => 618.00000000,
        :low24h => 618.00000000,
        :lowToday => 618.00000000,
        :openToday => 618.00000000,
        :pair => symbol.to_s.upcase,
        :servertimeUTC => 2014-06-24 20:42:35,
        :volume24h => 0.00040000,
        :volumeToday => 0.00040000,
        :vwap24h => 618.00000000,
        :vwapToday => 618.00000000
      }

### Order Book

    ruby > Itbit::XBTUSDMarketData.orders
    => {:bids=>[[632.0, 38.910443037975], [630.87, 1.8], ...],
        :asks=>[[634.9, 0.95], [648.0, 0.4809267], ...]}

### Trades

    ruby > Itbit::XBTUSDMarketData.transactions
    => [ {date: unix_timestamp, price: 123.5, amount: 1.97, tid: 98375},
         {date: unix_timestamp, price: 123.5, amount: 1.97, tid: 98376},
         ...]

## Use for Private Trading

### Authentication
TODO

### Get your balances, deposit addresses
TODO

### Place a Bid
TODO

### Place an Ask
TODO

### List your pending or recently active orders
TODO

### List your recent transactions
TODO

## Sandbox
TODO

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
