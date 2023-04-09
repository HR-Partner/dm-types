# frozen_string_literal: true

require 'dm-core'
require 'dm-types/yaml'

module DataMapper
  class Property
    class CommaSeparatedList < Yaml
      def dump(value)
        if value.nil?
          nil
        elsif value.is_a?(::Array)
          super(value)
        elsif value.is_a?(::String)
          v = []

          value.split(',').each do |element|
            element.strip!
            v << element unless element.empty?
          end

          super(v)
        else
          raise ArgumentError,
                "+value+ of CommaSeparatedList must be a string, an array or nil, but given #{value.inspect}"
        end
      end
    end
  end
end
