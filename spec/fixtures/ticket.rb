# frozen_string_literal: true

module DataMapper
  module TypesFixtures
    class Ticket
      #
      # Behaviors
      #

      include DataMapper::Resource
      include DataMapper::Validations

      #
      # Properties
      #

      property :id,     Serial
      property :title,  String, length: 255
      property :body,   Text
      property :status, Enum[:unconfirmed, :confirmed, :assigned, :resolved, :not_applicable]
    end
  end
end
