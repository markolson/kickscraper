describe Kickscraper::User do
  subject { client.find_user TEST_USER_ID }
  let(:client) { Kickscraper.client }

  context "loading all info for a user" do 

    its(:id) { should be > 0 }
    its(:name) { should_not be_empty }
    its(:avatar) { should have_at_least(0).items }
    its(:biography) { should_not be_empty }
    its(:backed_projects_count) { should_not be_nil }
    its(:created_at) { should be > 1262304000 }
      
    its(:backed_projects) { should have_at_least(0).items } 
    its(:starred_projects) { should have_at_least(0).items }
  end

  context "reloads" do
    before(:each) { subject.reload! }

    its(:id) { should eq TEST_USER_ID }
    its(:name) { should eq 'Zach Braff'}
  end

  
  context "loads the biography for a user that was brought in through a different API call" do
    let(:project) { client.find_project TEST_PROJECT_ID }
    subject { project.creator }
    
    its(:biography) { should_not be_empty }
  end
end