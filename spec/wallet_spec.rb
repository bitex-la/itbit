require 'spec_helper'

describe Itbit::Wallet do
  it 'lists all' do
    stub_get("/wallets", 'wallets', userId: Itbit.user_id)
    wallets = Itbit::Wallet.all
    wallets.size.should == 3
    wallets.first.should == {
      id: "fae1ce9a-848d-479b-b059-e93cb026cdf9",
      name: "primary",
      user_id: "326a3369-78fc-44e7-ad52-03e97371ca72",
      account_identifier: "PRIVATEBETA55-2285-2HN",
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
        },
      ]
    }
  end
  
  it 'creates a wallet' do
    stub_post("/wallets", 'wallet', name: 'Wallet', userId: Itbit.user_id)
    wallet = Itbit::Wallet.create!('Wallet')
    wallet[:id].should == "fae1ce9a-848d-479b-b059-e93cb026cdf9"
  end
end
