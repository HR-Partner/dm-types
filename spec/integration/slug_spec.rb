# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/article'

describe DataMapper::TypesFixtures::Article do
  supported_by :all do
    describe "persisted with title and slug set to 'New DataMapper Type'" do
      before :all do
        @input    = 'New DataMapper Type'
        @resource = DataMapper::TypesFixtures::Article.create(title: @input, slug: @input)

        @resource.reload
      end

      it 'has slug equal to "new-datamapper-type"' do
        @resource.slug.should == 'new-datamapper-type'
      end

      it 'can be found by slug' do
        DataMapper::TypesFixtures::Article.first(slug: 'new-datamapper-type').should == @resource
      end
    end
  end
end
