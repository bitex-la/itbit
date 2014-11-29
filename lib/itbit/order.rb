module Itbit
  # A limit buy or sell order, translated from itbit api to a more
  # suitable ruby style. Field names are underscored. Values 
  # for side, instrument, currency, type and status are 
  # underscored and symbolized.
  class Order
    attr_accessor :id, :wallet_id, :side, :instrument,
      :currency, :type, :amount, :price, :amount_filled,
      :volume_weighted_average_price, :created_time, :status,
      :display_amount, :metadata, :client_order_identifier
    
    def initialize(attrs)
      attrs.each{|k, v| send("#{k.underscore}=", v)}
    end
    
    %w(side instrument currency type status).each do |attr|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value.to_s.underscore.to_sym)
      end
    end

    %w(amount price amount_filled volume_weighted_average_price 
    display_amount).each do |attr|
      define_method("#{attr}=") do |value|
        instance_variable_set("@#{attr}", value.to_d)
      end
    end
    
    def created_time=(value)
      @created_time = value.is_a?(String) ? Time.parse(value).to_i : value
    end

    # Lists all orders for a wallet.
    # Results can be filtered and paginated by passing in these options.
    #  wallet_id: String, defaults to Itbit.default_wallet_id 
    #  instrument: Symbol, either :xbtusd, :xbteur, :xbtsgd
    #  page: Integer, starting page for pagination.
    #  per_page: Integer, how many to show per page.
    #  status: Symbol, either :submitted, :open, :filled, :cancelled, :rejected
    # @return [Array<Itbit::Order>]
    def self.all(opts = {})
      wallet_id = opts[:wallet_id] || Itbit.default_wallet_id
      params = {}
      params[:instrument] = opts[:instrument].upcase if opts[:instrument]
      params[:page] = opts[:page].to_i if opts[:page]
      params[:perPage] = opts[:per_page].to_i if opts[:per_page]
      params[:status] = opts[:status] if opts[:status]
      Api.request(:get, "/wallets/#{wallet_id}/orders", params)
        .collect{|o| Order.new(o) }
    end

    # Finds an order by id in a given wallet.
    # @param id [String] The order's uuid
    # @param wallet_id [String] Optional wallet's uuid, defaults to
    #   Itbit.default_wallet_id
    def self.find(id, wallet_id = Itbit.default_wallet_id)
      Order.new Api.request(:get, "/wallets/#{wallet_id}/orders/#{id}")
    end

    # Creates a new order
    # @param side [Symbol] :buy or :sell
    # @param instrument [Symbol] :xbtusd, :xbteur or :xbtsgd
    # @param amount [BigDecimal] Quantity to buy or sell
    # @param price [BigDecimal] Maximum price to pay when buying
    #   or minimum price to charge when selling.
    # @param options [Hash] Optional arguments
    #   wallet_id: [String] The wallet to use for placing this order
    #     defaults to Itbit.default_wallet_id
    #   wait: [Boolean] Block the process and wait until this
    #     order moves out of the :submitted state, defaults to false.
    #   type: Order type, only :limit is supported at the moment
    #   currency: Always :xbt, but left for compatibility.
    #   metadata: Arbitrary JSON data for your use.
    #   client_order_identifier: If you have your own ID for this
    #     order you can pass it in this field, *Make sure it's unique!*
    def self.create!(side, instrument, amount, price, options = {})
      wallet_id = options[:wallet_id] || Itbit.default_wallet_id
      params = {
        side: side,
        instrument: instrument.to_s.upcase,
        amount: amount.to_d.to_s('F'),
        price: price.to_d.to_s('F'),
        type: options[:type] || :limit,
        currency: options[:currency].try(:upcase) || 'XBT'
      }
      %w(metadata client_order_identifier).each do |a|
        params[a.camelize(:lower)] = options[a.to_sym] if options[a.to_sym]
      end

      order = Order.new Api.request(:post, "/wallets/#{wallet_id}/orders", params)
      retries = 0
      while options[:wait] && order.status == :submitted
        sleep 0.2
        begin 
          order = find(order.id)
        rescue StandardError => e
        end
        retries += 1
        if retries > 5000 # Wait 15 minutes for the order to be accepted.
          raise StandardError.new(
            "Timed out waiting for #{base_path} ##{order.id}")
        end
      end
      return order
    end
  
    # Cancel this order
    def cancel!
      Api.request(:delete, "/wallets/#{wallet_id}/orders/#{id}")
      self.status = :cancelling
      return self
    rescue RestClient::UnprocessableEntity
      return nil
    end
  end
end
