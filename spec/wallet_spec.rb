require 'spec_helper'

describe Itbit::Wallet do
  it 'lists all' do
    stub_get("/wallets", 'wallets', userId: Itbit.user_id)
    wallets = Itbit::Wallet.all
    wallets.size.should == 2
    wallets.first.should == {
      id: "3F2504E0-4F89-41D3-9A0C-0305E82C3301",
      name: "Wallet",
      balances: [
        { balance: "10203.25".to_d,
          currency_code: :usd,
          trading_balance: "10003.25".to_d
        },
        { balance: "402.110".to_d,
          currency_code: :xbt,
          trading_balance: "402.110".to_d
        },
        { balance: "0.00".to_d,
          currency_code: :eur,
          trading_balance: "0.00".to_d
        }
      ]
    }
  end
  
  it 'creates a wallet' do
    stub_post("/wallets", 'wallet', name: 'Wallet', userId: Itbit.user_id)
    wallet = Itbit::Wallet.create!('Wallet')
    wallet[:id].should == "3F2504E0-4F89-41D3-9A0C-0305E82C3301"
  end
end
