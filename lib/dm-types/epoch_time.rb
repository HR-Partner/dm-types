# frozen_string_literal: true

require 'dm-core'

module DataMapper
  class Property
    class EpochTime < Time
      dump_as ::Integer

      def load(value)
        if value.is_a?(::Numeric)
          ::Time.at(value.to_i)
        else
          value
        end
      end

      def dump(value)
        value&.to_i
      end

      def typecast(value)
        case value
        when ::Time               then value
        when ::Numeric, /\A\d+\z/ then ::Time.at(value.to_i)
        when ::DateTime           then datetime_to_time(value)
        when ::String             then ::Time.parse(value)
        end
      end

      private

      def datetime_to_time(datetime)
        utc = datetime.new_offset(0)
        ::Time.utc(utc.year, utc.month, utc.day, utc.hour, utc.min, utc.sec)
      end
    end
  end
end
