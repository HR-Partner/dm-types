# frozen_string_literal: true

require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-types'
require 'dm-migrations'
require 'dm-validations'

Dir["#{Pathname(__FILE__).dirname.expand_path}/shared/*.rb"].sort.each { |file| require file }

DataMapper::Spec.setup
RSpec.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
  config.before(:suite) do
    DataMapper.auto_migrate!
  end
end

DEPENDENCIES = {
  'bcrypt' => 'bcrypt-ruby'
}.freeze
