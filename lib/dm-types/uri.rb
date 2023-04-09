# frozen_string_literal: true

require 'addressable/uri'
require 'dm-core'

module DataMapper
  class Property
    class URI < String
      # allow_nil false
      load_as Addressable::URI

      # Maximum length chosen based on recommendation:
      # http://stackoverflow.com/questions/417142/what-is-the-maximum-length-of-an-url
      length 2083

      def load(value)
        return if value.nil?

        uri = Addressable::URI.parse(value)
        uri&.normalize
      end

      def dump(value)
        value&.to_str
      end

      def typecast(value)
        return if value.nil?

        load(value)
      end
    end
  end
end
