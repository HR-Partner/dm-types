# frozen_string_literal: true

require 'dm-core'
require 'dm-types/support/dirty_minder'
require 'csv'

module DataMapper
  class Property
    class Csv < String
      load_as ::Array

      def load(value)
        case value
        when ::String then CSV.parse(value)
        when ::Array  then value
        end
      end

      def dump(value)
        case value
        when ::Array
          CSV.generate { |csv| value.each { |row| csv << row } }
        when ::String then value
        end
      end

      include ::DataMapper::Property::DirtyMinder
    end
  end
end
