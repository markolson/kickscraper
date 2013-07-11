@root_dir = File.expand_path(File.join(File.dirname(__FILE__), "../"))

$: << './'
$: << File.join(@root_dir, "lib", "kickscraper")
$: << File.join(@root_dir, "lib", "kickscraper", "client")
$: << File.join(@root_dir, "spec")

Dir["./spec/support/**/*.rb"].each {|f| require f}

require 'rubygems'
require 'rspec'
require 'kickscraper'
require 'test_constants'

# initialize kickscraper
Kickscraper.configure do |config|
    config.email = KICKSCRAPER_TEST_API_EMAIL
    config.password = KICKSCRAPER_TEST_API_PASSWORD
    config.proxy = LOCAL_PROXY if defined? LOCAL_PROXY
end

RSpec.configure do |config|
  config.alias_it_should_behave_like_to :it_returns, "returns"
end