require 'spec_helper'

describe Itbit::MarketData do

  { xbtusd: Itbit::XBTUSDMarketData,
    xbtsgd: Itbit::XBTSGDMarketData,
    xbteur: Itbit::XBTEURMarketData
  }.each do |symbol, market_data|
    describe "when getting #{symbol} market data" do
      it "gets the ticker" do
        stub_get("/markets/#{symbol}/ticker", "market_ticker_#{symbol}")
        market_data.ticker.should == {
          :ask => "641.29".to_d,
          :askAmt => "0.5".to_d,
          :bid => "622".to_d,
          :bidAmt => "0.0006".to_d,
          :high24h => "618.00000000".to_d,
          :highToday => "618.00000000".to_d,
          :lastAmt => "0.00040000".to_d,
          :lastPrice => "618.00000000".to_d,
          :low24h => "618.00000000".to_d,
          :lowToday => "618.00000000".to_d,
          :openToday => "618.00000000".to_d,
          :pair => symbol.to_s.upcase,
          :servertimeUTC => Time.parse("2014-06-24T20:42:35.6160000Z"),
          :volume24h => "0.00040000".to_d,
          :volumeToday => "0.00040000".to_d,
          :vwap24h => "618.00000000".to_d,
          :vwapToday => "618.00000000".to_d,
        }
      end
      
      it "gets the order book" do
        stub_old("/markets/#{symbol.upcase}/orders", 'order_book')
        market_data.orders.should == {
          bids: [[639.21,1.95],[637.0,0.47],[630.0,1.58]],
          asks: [[642.4,0.4],[643.3,0.95],[644.3,0.25]]
        }
      end
      
      it "gets the trades" do
        stub_old("/markets/#{symbol.upcase}/trades", 'trades', since: 0)
        trades = market_data.trades
        trades.size.should == 6
        trades.first.tap do |t|
          t[:date].should == 1415218064
          t[:price].should == 340.0
          t[:amount].should == 1.9718
          t[:tid].should == 98375
        end
      end
    end
  end
end
