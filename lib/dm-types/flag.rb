# frozen_string_literal: true

require 'dm-core'
require 'dm-types/support/flags'

module DataMapper
  class Property
    class Flag < Object
      include Flags

      load_as ::Object
      dump_as ::Integer

      def initialize(model, name, options = {})
        super

        @flag_map = {}

        flags = options.fetch(:flags, self.class.flags)
        flags.each_with_index do |flag, i|
          flag_map[i] = flag
        end
      end

      def load(value)
        return [] if value.nil? || value <= 0

        begin
          matches = []

          0.upto(flag_map.size - 1) do |i|
            matches << flag_map[i] if value[i] == 1
          end

          matches.compact
        rescue TypeError, Errno::EDOM
          []
        end
      end

      def dump(value)
        return if value.nil?

        flags = Array(value).map(&:to_sym)
        flags.uniq!

        flag = 0

        flag_map.invert.values_at(*flags).each do |i|
          next if i.nil?

          flag += (1 << i)
        end

        flag
      end

      def typecast(value)
        case value
        when nil     then nil
        when ::Array then value.map(&:to_sym)
        else [value.to_sym]
        end
      end
    end
  end
end
