require "rack/test"

require "factory_bot"
require "faker"
require "pry"

ENV["RACK_ENV"] = "test"

require File.expand_path "../app/server.rb", __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include RSpecMixin

  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    # FactoryBot.find_definitions
  end
end
