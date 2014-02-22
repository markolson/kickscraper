require "bundler/gem_tasks"

task :console do
  require 'irb'
  require 'irb/completion'
  require 'kickscraper'
  
  require './spec/test_constants'
  
  Kickscraper.configure do |config|
      config.email = KICKSCRAPER_TEST_API_EMAIL
      config.password = KICKSCRAPER_TEST_API_PASSWORD
      config.proxy = LOCAL_PROXY if defined? LOCAL_PROXY
  end
  
  ARGV.clear
  IRB.start
end