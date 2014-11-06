module Itbit
  # Your ItBit wallets, translated from itbit api to a more
  # suitable ruby style. Field names are underscored.
  # Values for balance and trading_balance are
  # converted to BigDecimal
  class Wallet
    # Lists all wallets.
    def self.all
      Api.request(:get, "/wallets", userId: Itbit.user_id)
        .collect { |wallet| translate_wallet(wallet) }
    end

    # Creates a new order
    # @param name [String] The name for the new wallet.
    def self.create!(name)
      translate_wallet(Api.request(:post, "/wallets", name: name, userId: Itbit.user_id))
    end

    def self.translate_wallet(wallet)
      wallet.symbolize_keys!
      wallet[:balances] = wallet[:balances].dup.collect do |b|
        { balance: b['balance'].to_d,
          currency_code: b['currencyCode'].downcase.to_sym,
          trading_balance: b['tradingBalance'].to_d
        }
      end
      wallet
    end
  end
end
