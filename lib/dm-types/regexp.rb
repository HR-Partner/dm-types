# frozen_string_literal: true

require 'dm-core'

module DataMapper
  class Property
    class Regexp < String
      load_as ::Regexp

      def load(value)
        ::Regexp.new(value) unless value.nil?
      end

      def dump(value)
        value&.source
      end

      def typecast(value)
        load(value)
      end
    end
  end
end
