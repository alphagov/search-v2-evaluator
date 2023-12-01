require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"

# We're using rack-test for simplicity, but we need to be able to find fields in <details> elements
Capybara.ignore_hidden_elements = false

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # We don't have JS, so rack_test will suffice
    driven_by :rack_test
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.order = :random
  Kernel.srand config.seed

  config.use_active_record = false

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  if config.files_to_run.one?
    # Use the documentation formatter for detailed output,
    # unless a formatter has already been configured
    # (e.g. via a command-line flag).
    config.default_formatter = "doc"
  end
end
