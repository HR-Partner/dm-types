# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/person'

describe DataMapper::TypesFixtures::Person do
  let(:save) { true }
  before :each do
    @resource = DataMapper::TypesFixtures::Person.new(name: '')
    @resource.interests = interests
    if save
      @resource.save.should be(true)
      @resource.reload
    end
  end

  describe 'with no interests information' do
    let(:interests) { nil }

    describe 'when dumped and loaded again' do
      it 'has no interests' do
        @resource.interests.should.nil?
      end
    end
  end

  describe 'with no interests information' do
    let(:interests) { [] }

    describe 'when dumped and loaded again' do
      it 'has empty interests list' do
        @resource.interests.should == []
      end
    end
  end

  describe 'with a few items on the interests list' do
    let(:interests) { 'fire, water, fire, a whole lot of other interesting things, ,,,' }

    describe 'when dumped and loaded again' do
      it 'includes "fire" in interests' do
        @resource.interests.should include('fire')
      end

      it 'includes "water" in interests' do
        @resource.interests.should include('water')
      end

      it 'includes "a whole lot of other interesting things" in interests' do
        expect(@resource.interests).to include('a whole lot of other interesting things')
      end

      it 'has blank entries removed' do
        @resource.interests.any? { |i| DataMapper::Ext.blank?(i) }.should be(false)
      end
    end
  end

  describe 'with interests information given as a Hash' do
    let(:interests) { { hash: 'value' } }
    let(:save) { false }
    it 'raises ArgumentError' do
      lambda do
        @resource.save
      end.should raise_error(ArgumentError, /must be a string, an array or nil/)
    end
  end
end
