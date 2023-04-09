# frozen_string_literal: true

module DataMapper
  module TypesFixtures
    class Article
      #
      # Behaviors
      #

      include ::DataMapper::Resource

      #
      # Properties
      #

      property :id,         Serial

      property :title,      String, length: 255
      property :body,       Text

      property :created_at,   DateTime
      property :updated_at,   DateTime
      property :published_at, DateTime

      property :slug, Slug

      #
      # Hooks
      #

      before :valid? do
        self.slug = title
      end
    end
  end
end
