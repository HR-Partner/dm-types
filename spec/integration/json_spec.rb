# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/person'

describe DataMapper::TypesFixtures::Person do
  supported_by :all do
    before :all do
      @resource = DataMapper::TypesFixtures::Person.new(name: 'Thomas Edison')
    end

    describe 'with no positions information' do
      before :all do
        @resource.positions = nil
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be(true)
          @resource.reload
        end

        it 'has nil positions list' do
          @resource.positions.should be_nil
        end
      end
    end

    describe 'with a few items on the positions list' do
      before :all do
        @resource.positions = [
          { company: 'The Death Star, Inc', title: 'Light sabre engineer'    },
          { company: 'Sane Little Company', title: 'Chief Curiosity Officer' }
        ]
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be(true)
          @resource.reload
        end

        it 'loads positions list to the state when it was dumped/persisted with keys being strings' do
          @resource.positions.should == [
            { 'company' => 'The Death Star, Inc', 'title' => 'Light sabre engineer' },
            { 'company' => 'Sane Little Company', 'title' => 'Chief Curiosity Officer' }
          ]
        end
      end
    end

    describe 'with positions information given as empty list' do
      before :all do
        @resource.positions = []
      end

      describe 'when dumped and loaded again' do
        before :all do
          @resource.save.should be(true)
          @resource.reload
        end

        it 'has empty positions list' do
          @resource.positions.should == []
        end
      end
    end
  end
end
