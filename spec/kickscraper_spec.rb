describe Kickscraper do
  subject { Kickscraper.client }

  it "accepts configuration" do
    Kickscraper.email.should == KICKSCRAPER_TEST_API_EMAIL
  end
  
  context "connects to the kickstarter api" do
    it { should_not be_nil }
    it { should be_a Kickscraper::Client }
    
    its(:user) { should_not be_nil }
    its(:user) { should be_a Kickscraper::User }
  end

end