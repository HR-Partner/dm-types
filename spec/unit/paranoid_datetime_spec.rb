# frozen_string_literal: true

require 'spec_helper'

xdescribe 'DataMapper::Property::ParanoidDateTime' do
  before :each do
    if defined?(Blog)
      Blog::Article.destroy!
      Object.send(:remove_const, :Blog)
    end
    module ::Blog
      class Draft
        include DataMapper::Resource

        property :id,         Serial
        property :deleted_at, ParanoidDateTime

        before :destroy, :before_destroy

        def before_destroy; end
      end

      class Article < Draft; end

      class Review < Article; end
    end
    DataMapper.auto_migrate!
    @model = Blog::Article
  end

  supported_by :all do
    describe 'Resource#destroy' do
      subject { @resource.destroy }

      describe 'with a new resource' do
        before do
          @resource = @model.new
        end

        it { should be(false) }

        it 'should not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(0)
        end

        it 'should not set the paranoid column' do
          expect { method(:subject) }.not_to change { @resource.deleted_at }.from(nil)
        end

        it 'should run the destroy hook' do
          @resource.should_receive(:before_destroy).with(no_args)
          subject
        end
      end

      describe 'with a saved resource' do
        before do
          @resource = @model.create
        end

        it { should be(true) }

        it 'should not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(1)
        end

        it 'should set the paranoid column' do
          expect { method(:subject) }.to change { @resource.deleted_at }.from(nil)
        end

        it 'should run the destroy hook' do
          @resource.should_receive(:before_destroy).with(no_args)
          subject
        end
      end
    end

    describe 'Resource#destroy!' do
      subject { @resource.destroy! }

      describe 'with a new resource' do
        before do
          @resource = @model.new
        end

        it { should be(false) }

        it 'should not delete the resource from the datastore' do
          expect { method(:subject) }.not_to change { @model.with_deleted.size }.from(0)
        end

        it 'should not set the paranoid column' do
          expect { subject }.not_to change { @resource.deleted_at }.from(nil)
        end

        it 'should not run the destroy hook' do
          @resource.should_not_receive(:before_destroy).with(no_args)
          subject
        end
      end

      describe 'with a saved resource' do
        before do
          @resource = @model.create
        end

        it { should be(true) }

        it 'should delete the resource from the datastore' do
          expect { method(:subject) }.to change { @model.with_deleted.size }.from(1).to(0)
        end

        it 'should not set the paranoid column' do
          expect { method(:subject) }.not_to change { @resource.deleted_at }.from(nil)
        end

        it 'should not run the destroy hook' do
          @resource.should_not_receive(:before_destroy).with(no_args)
          subject
        end
      end
    end

    describe 'Model#with_deleted' do
      before do
        @resource = @model.create
        @resource.destroy
      end

      describe 'with a block' do
        subject { @model.with_deleted { @model.all } }

        it 'should scope the block to return all resources' do
          subject.map(&:key).should == [@resource.key]
        end
      end

      describe 'without a block' do
        subject { @model.with_deleted }

        it 'should return a collection scoped to return all resources' do
          subject.map(&:key).should == [@resource.key]
        end
      end
    end

    describe 'Model.inherited' do
      it 'sets @paranoid_properties' do
        ::Blog::Review.instance_variable_get(:@paranoid_properties).should ==
          ::Blog::Article.instance_variable_get(:@paranoid_properties)
      end
    end
  end
end
