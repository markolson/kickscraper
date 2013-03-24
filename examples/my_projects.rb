require 'kickscraper'

p "configuring.."
Kickscraper.configure do |config|
    config.email = 'your-kickstarter-email-address@domain.com'
    config.password = 'This is not my real password. Seriously.'
end

p "logging in.."
c = Kickscraper.client
p "got access token #{Kickscraper.token.gsub(/\w{30}$/, "X" * 30)}"
puts " Active | Met Goal |"
puts "--------------------"
c.user.backed_projects.each {|x| 
    print (x.active? ? '    X   |' : '        |')
    print (x.successful? ? '    X     | ' : '          | ')
    puts x.name
}
