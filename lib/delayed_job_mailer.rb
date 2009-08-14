module Delayed
  module AsynchMailer
    def self.included(base)
      base.class_eval do
        class << self
          alias_method :orig_method_missing, :method_missing

          def method_missing(method_symbol, *params)
            case method_symbol.id2name
            when /^deliver_([_a-z]\w*)\!/ then orig_method_missing(method_symbol, *params)
            when /^deliver_([_a-z]\w*)/ then self.send_later(method_symbol, *params)
            else orig_method_missing(method_symbol, *params)
            end
          end
        end
      end
    end
  end
end
