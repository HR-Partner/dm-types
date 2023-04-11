# frozen_string_literal: true

require 'spec_helper'

require './spec/fixtures/bookmark'

xdescribe DataMapper::TypesFixtures::Bookmark do
  supported_by :all do
    before :all do
      DataMapper::TypesFixtures::Bookmark.auto_migrate!
    end

    let(:resource) do
      DataMapper::TypesFixtures::Bookmark.create(
        title: 'Check this out',
        uri: uri,
        shared: false,
        tags: %w[misc]
      )
    end

    before do
      expect(resource).to be_saved
    end

    context 'without URI' do
      let(:uri) { nil }

      it 'can be found by uri' do
        expect(DataMapper::TypesFixtures::Bookmark.first(uri: uri)).to eql(resource)
      end

      describe 'when reloaded' do
        before do
          resource.reload
        end

        it 'has no uri' do
          expect(resource.uri).to be(nil)
        end
      end
    end

    describe 'with a blank URI' do
      let(:uri) { '' }

      it 'can be found by uri' do
        expect(DataMapper::TypesFixtures::Bookmark.first(uri: uri)).to eql(resource)
      end

      describe 'when reloaded' do
        before do
          resource.reload
        end

        it 'is loaded as URI object' do
          expect(resource.uri).to be_an_instance_of(Addressable::URI)
        end

        it 'has the same original URI' do
          expect(resource.uri.to_s).to eql(uri)
        end
      end
    end

    describe 'with invalid URI' do
      let(:uri) { 'this is def. not URI' }

      it 'is perfectly valid (URI type does not provide auto validations)' do
        expect(resource.save).to be_truthy # (true)
      end
    end

    %w[
      http://www.hulu.com/watch/62475/the-simpsons-gone-maggie-gone#s-p1-so-i0
    ].each do |uri|
      describe "with URI set to '#{uri}'" do
        let(:uri) { uri }

        it 'can be found by uri' do
          expect(DataMapper::TypesFixtures::Bookmark.first(uri: uri)).not_to be(nil)
        end

        describe 'when reloaded' do
          before do
            resource.reload
          end

          it 'matches a normalized form of the original URI' do
            expect(resource.uri).to eql(Addressable::URI.parse(uri).normalize)
          end
        end
      end
    end
  end
end
