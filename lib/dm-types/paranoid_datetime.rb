# frozen_string_literal: true

require 'dm-types/paranoid/base'

module DataMapper
  class Property
    class ParanoidDateTime < DateTime
      lazy true

      # @api private
      def bind
        property_name = name.inspect

        model.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          include DataMapper::Types::Paranoid::Base

          set_paranoid_property(#{property_name}) { ::DateTime.now }

          default_scope(#{repository_name.inspect}).update(#{property_name} => nil)
        RUBY
      end
    end
  end
end
