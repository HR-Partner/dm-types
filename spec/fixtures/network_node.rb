# frozen_string_literal: true

module DataMapper
  module TypesFixtures
    class NetworkNode
      #
      # Behaviors
      #

      include ::DataMapper::Resource

      #
      # Properties
      #

      property :id,               Serial
      property :ip_address,       IPAddress
      property :cidr_subnet_bits, Integer
      property :node_uuid,        UUID

      #
      # API
      #

      alias uuid node_uuid
      alias uuid= node_uuid=

      def runs_ipv6?
        ip_address.ipv6?
      end

      def runs_ipv4?
        ip_address.ipv4?
      end
    end
  end
end
