# frozen_string_literal: true

require 'dm-core'
require 'bcrypt'

module DataMapper
  class Property
    class BCryptHash < String
      load_as BCrypt::Password

      length 60

      def load(value)
        typecast(value)
      end

      def dump(value)
        hash = typecast(value)
        return if hash.nil?

        hash_string = hash.to_s
        hash_string.encode!('UTF-8') if hash_string.respond_to?(:encode!)
        hash_string
      end

      def typecast(value)
        return value if value.nil? || value.is_a?(BCrypt::Password)

        BCrypt::Password.new(value)
      rescue BCrypt::Errors::InvalidHash
        BCrypt::Password.create(value)
      end
    end
  end
end
