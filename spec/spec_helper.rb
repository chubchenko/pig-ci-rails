# require 'rubygems'

# Coverage
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

require 'tmpdir'

require 'pig_ci'
PigCI.output_directory = Pathname.new(Dir.mktmpdir)
PigCI.tmp_directory = Pathname.new(Dir.mktmpdir)
PigCI.run_timestamp = '100'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  # config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  # config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

at_exit do
  FileUtils.remove_entry PigCI.output_directory
  FileUtils.remove_entry PigCI.tmp_directory
end
