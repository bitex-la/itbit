module Itbit
  # Utility class for fetching an heterogeneous list of objects that
  # compose your transaction history.
  class Transaction 
    # @return [Array<Itbit::Buy, Itbit::Sell, Itbit::SpecieDeposit,
    #   Itbit::SpecieWithdrawal, Itbit::UsdDeposit, Itbit::UsdWithdrawal>]
    #   Returns an heterogeneous array with all your transactions for the past
    #   30 days sorted by descending date.
    def self.all
      Api.private(:GET, '/private/transactions').collect{|o| Api.deserialize(o) }
    end
  end
end
