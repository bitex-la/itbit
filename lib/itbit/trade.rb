module Itbit
  # List the full trading history for a given wallet
  class Trade
    attr_accessor :order_id, :direction, :commission_paid, :timestamp,
      :rebates_applied, :currency2, :instrument, :rate, :currency1,
      :rebate_currency, :currency1_amount, :currency2_amount,
      :commission_currency
    
    def initialize(attrs)
      attrs.each{|k, v| send("#{k.underscore}=", v)}
    end
    
    %w(direction instrument currency1 currency2
    rebate_currency commission_currency).each do |attr|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value.to_s.underscore.to_sym)
      end
    end

    %w(commission_paid rebates_applied rate
    currency1_amount currency2_amount).each do |attr|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value.to_d)
      end
    end
  
    def timestamp=(value)
      @timestamp = value.is_a?(String) ? Time.parse(value).to_i : value
    end

    # Lists all trades for a wallet
    # Results can be filtered and paginated by passing in these options.
    #  wallet_id: String, defaults to Itbit.default_wallet_id 
    #  page: Integer, starting page for pagination.
    #  per_page: Integer, how many to show per page.
    #  range_start: Integer timestamp, start showing at this date.
    #  range_end: Integer timestamp, stop showing at this date.
    # @return [Array<Itbit::Trade>]
    def self.all(opts = {})
      wallet_id = opts[:wallet_id] || Itbit.default_wallet_id
      params = {}
      %w(range_start range_end page per_page).each do |a|
        params[a.camelize(:lower)] = opts[a.to_sym].to_i if opts[a.to_sym]
      end
      response = Api.request(:get, "/wallets/#{wallet_id}/trades", params)
      {
        total_number_of_records: response['totalNumberOfRecords'].to_i,
        current_page_number: response['currentPageNumber'].to_i,
        latest_execution_id: response['latestExecutionId'].to_i,
        records_per_page: response['recordsPerPage'].to_i,
        trading_history: response['tradingHistory'].collect{|x| new(x) }
      }
    end
  end
end
