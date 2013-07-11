guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{kickscraper/(?:client/)?(.+)\.rb$})  { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
  watch(%r{spec/support/.*\.rb$})  { "spec" }
end