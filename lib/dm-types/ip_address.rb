# frozen_string_literal: true

require 'ipaddr'
require 'dm-core'

module DataMapper
  class Property
    class IPAddress < String
      load_as IPAddr

      length 39

      def load(value)
        if value.nil? || value_loaded?(value)
          value
        elsif value.is_a?(::String)
          if value.empty?
            IPAddr.new('0.0.0.0')
          else
            IPAddr.new(value)
          end
        else
          raise ArgumentError, '+value+ must be nil or a String'
        end
      end

      def dump(value)
        value&.to_s
      end

      def typecast(value)
        load(value) unless value.nil?
      end
    end
  end
end
