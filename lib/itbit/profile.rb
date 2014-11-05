module Itbit
  # Your balances, fee and deposit addresses
  class Profile
    # Your profile conveniently formatted as a ruby hash with symbolized keys.
    def self.get
      Api.private(:GET, '/private/profile').symbolize_keys
    end
  end
end
