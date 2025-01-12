# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/tshirt'

xdescribe 'DataMapper::Property::Flag' do
  describe '.dump' do
    before :all do
      @flag = DataMapper::TypesFixtures::TShirt.property(
        :stuff, DataMapper::Property::Flag[:first, :second, :third, :fourth, :fifth]
      )

      @property_klass = DataMapper::Property::Flag
    end

    it_should_behave_like 'A property with flags'

    describe 'when argument matches a value in the flag map' do
      before :all do
        @result = @flag.dump(:first)
      end

      it 'returns flag bit of value' do
        @result.should == 1
      end
    end

    describe 'when argument matches 2nd value in the flag map' do
      before :all do
        @result = @flag.dump(:second)
      end

      it 'returns flag bit of value' do
        @result.should == 2
      end
    end

    describe 'when argument matches multiple Symbol values in the flag map' do
      before :all do
        @result = @flag.dump(%i[second fourth])
      end

      it 'builds binary flag from key values of all matches' do
        @result.should == 10
      end
    end

    describe 'when argument matches multiple string values in the flag map' do
      before :all do
        @result = @flag.dump(%w[first second third fourth fifth])
      end

      it 'builds binary flag from key values of all matches' do
        @result.should == 31
      end
    end

    describe 'when argument does not match a single value in the flag map' do
      before :all do
        @result = @flag.dump(:zero)
      end

      it 'returns zero' do
        @result.should == 0
      end
    end

    describe 'when argument contains duplicate flags' do
      before :all do
        @result = @flag.dump(%i[second fourth second])
      end

      it 'behaves the same as if there were no duplicates' do
        @result.should == @flag.dump(%i[second fourth])
      end
    end
  end

  describe '.load' do
    before :all do
      @flag = DataMapper::TypesFixtures::TShirt.property(:stuff, DataMapper::Property::Flag,
                                                         flags: %i[uno dos tres cuatro cinco])
    end

    describe 'when argument matches a key in the flag map' do
      before :all do
        @result = @flag.load(4)
      end

      it 'returns array with a single matching element' do
        @result.should == [:tres]
      end
    end

    describe 'when argument matches multiple keys in the flag map' do
      before :all do
        @result = @flag.load(10)
      end

      it 'returns array of matching values' do
        @result.should == %i[dos cuatro]
      end
    end

    describe 'when argument does not match a single key in the flag map' do
      before :all do
        @result = @flag.load(nil)
      end

      it 'returns an empty array' do
        @result.should == []
      end
    end
  end
end
