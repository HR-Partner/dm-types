# frozen_string_literal: true

module DataMapper
  class Property
    module Flags
      def self.included(base)
        base.class_eval <<-RUBY, __FILE__, __LINE__ + 1
          extend DataMapper::Property::Flags::ClassMethods

          accept_options :flags
          attr_reader :flag_map

          class << self
            attr_accessor :generated_classes
          end

          self.generated_classes = {}
        RUBY
      end

      def custom?
        true
      end

      module ClassMethods
        # TODO: document
        # @api public
        def [](*values)
          unless (klass = generated_classes[values.flatten])
            klass = ::Class.new(self)
            klass.flags(values)

            generated_classes[values.flatten] = klass

          end
          klass
        end
      end
    end
  end
end
