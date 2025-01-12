# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/person'

describe DataMapper::TypesFixtures::Person do
  supported_by :all do
    before :all  do
      @resource  = DataMapper::TypesFixtures::Person.create(password: 'DataMapper R0cks!')
      DataMapper::TypesFixtures::Person.create(password: 'password1')

      @people = DataMapper::TypesFixtures::Person.all
      @resource.reload
    end

    it 'persists the password on initial save' do
      @resource.password.should    == 'DataMapper R0cks!'
      @people.last.password.should == 'password1'
    end

    it 'recalculates password hash on attribute update' do
      @resource.attribute_set(:password, 'bcryptic obscure')
      @resource.save

      @resource.reload
      @resource.password.should     == 'bcryptic obscure'
      @resource.password.should_not == 'DataMapper R0cks!'
    end

    it 'does not change password value on reload' do
      resource = @people.last
      original = resource.password.to_s
      resource.reload
      resource.password.to_s.should == original
    end

    it 'uses cost of BCrypt::Engine::DEFAULT_COST' do
      @resource.password.cost.should == BCrypt::Engine::DEFAULT_COST
    end

    it 'allows Bcrypt::Password#hash to be an Integer' do
      @resource.password.hash.should be_kind_of(Integer)
    end
  end
end
