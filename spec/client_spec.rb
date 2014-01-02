describe Kickscraper::Client do
  let(:client) { Kickscraper.client }
  
  context "finds a user by id" do
    subject(:user) { client.find_user TEST_USER_ID }
    
    its(:id) { should == TEST_USER_ID }
    its(:name) { should == 'Zach Braff' }
  end
  
  context "returns nil when finding a non-existent user" do
    subject { client.find_user 9999 }

    it { should be_nil }
  end
  
  context "finds a project by id" do
    subject(:project) { client.find_project TEST_PROJECT_ID }
    
    its(:id) { should == TEST_PROJECT_ID }
    its(:slug) { should == TEST_PROJECT_SLUG }
    its(:name) { should == TEST_PROJECT_NAME }
  end
  
  context "finds a project by slug" do
    subject(:project) { client.find_project TEST_PROJECT_SLUG }
    
    its(:id) { should == TEST_PROJECT_ID }
    its(:slug) { should == TEST_PROJECT_SLUG }
    its(:name) { should == TEST_PROJECT_NAME }
  end
  
  context "returns nil when finding a non-existent project" do
    subject { client.find_project 9999 }
    it { should be_nil }
  end
  
  context "searches projects with a keyword" do
    subject { client.search_projects 'arduino' }
    it_returns "a collection", Kickscraper::Project
  end
  
  it "searches projects for a specific one" do
    projects = client.search_projects 'Spark Core Wi-Fi for Everything'
    projects.length.should be > 0
    projects[0].id.should be 373368980
  end
  
  it "handles searching for projects with special characters" do
    projects = client.search_projects %q{"angels" & demons !@#$'%^&*()}
    projects.length.should be > 0
  end
  
  it "returns an empty array when searching for projects and finding nothing" do
    projects = client.search_projects "asfakjssdklfjsafajdfklafjdsl"
    projects.should be_an(Array)
    projects.should be_empty
  end
  
  context "finds projects ending soon" do
    subject { client.ending_soon_projects }

    it_returns "a collection", Kickscraper::Project
  end
  
  context "finds popular projects" do
    subject { client.popular_projects }
    it_returns "a collection", Kickscraper::Project
  end
  
  context "finds recently launched projects" do
    subject { client.recently_launched_projects }
    it_returns "a collection", Kickscraper::Project
  end
  
  context "finds recently launched projects with the 'newest_projects' method for backwards compatibility" do
    subject { client.newest_projects }
    it_returns "a collection", Kickscraper::Project
  end
  
  # context "loads more projects after a successful search" do
  #   subject do 
  #     client.recently_launched_projects
  #     client.more_projects_available?.should be_true
  #     client.load_more_projects 
  #   end

  #   it_returns "a collection", Kickscraper::Project
  # end
  
  # context "doesn't load more projects after an unsuccessful search" do
  #   before { client.search_projects "asfakjssdklfjsafajdfklafjdsl" }
  #   its(:more_projects_available?) { should be_false }
  # end

  # context "loads recently launched projects starting at a specific timestamp" do
  #   subject { client.recently_launched_projects((Time.now - (2 * 24 * 60 * 60)).to_i) }
  #   it_returns "a collection", Kickscraper::Project
  # end
  
  context "loads popular projects starting at a specific page" do
    subject { client.popular_projects(30) }
    it_returns "a collection", Kickscraper::Project
  end
  
  # context "loads projects ending soon starting at a specific deadline" do
  #   subject { client.ending_soon_projects((Time.now + (2 * 24 * 60 * 60)).to_i) }
  #   it_returns "a collection", Kickscraper::Project
  # end
  
  context "searches for projects starting at a specific page of results" do
    subject { client.search_projects('arduino', 2) }
    it_returns "a collection", Kickscraper::Project
  end

  context "lists all categories" do
    subject { client.categories }  
    it_returns "a collection", Kickscraper::Category
  end

  context "loads a category from string" do
    subject { client.category(TEST_CATEGORY_NAME) }
    its(:name) { should eq TEST_CATEGORY_NAME }
  end

  context "loads a category from an id" do
    subject { client.category(TEST_CATEGORY_ID) }
    its(:name) { should eq TEST_CATEGORY_NAME }
  end

end
