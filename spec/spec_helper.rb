$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'fm-belief-network'
require 'rspec/autorun'

# Requires supporting ruby files in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}
Dir[File.join(File.dirname(__FILE__), "behavior/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # config.filter_run :focus => true
  config.filter_run_excluding :slow => true
end

