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
  
  describe ".ending_soon_projects" do
    it_behaves_like "ending_soon projects"
  end

  describe ".recently_launched_project" do
    it_behaves_like "recently_launched projects"
  end

  # findes recently launched projects with the 'newest_projects' method for backwards compatibility
  describe ".newest_projects" do
    it_behaves_like "newest_projects projects"
  end

  describe ".popular_projects" do
    it_behaves_like "popular projects"
  end

  describe ".search_project" do
    it_behaves_like "search projects"
  end

  # context "loads recently launched projects starting at a specific timestamp" do
  #   subject { client.recently_launched_projects((Time.now - (2 * 24 * 60 * 60)).to_i) }
  #   it_returns "a collection", Kickscraper::Project
  # end
  
  # context "loads projects ending soon starting at a specific deadline" do
  #   subject { client.ending_soon_projects((Time.now + (2 * 24 * 60 * 60)).to_i) }
  #   it_returns "a collection", Kickscraper::Project
  # end
  
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

  context "returns an array of updates when a valid project is loaded" do
    subject { client.find_project(TEST_PROJECT_ID).updates }
    it_returns "a collection", Kickscraper::Update
  end

  context "loads more updates when available" do
    before { client.find_project(TEST_PROJECT_ID) }
    subject do
      client.more_updates_available?.should be_true
      client.load_more_updates
    end

    it_returns "a collection", Kickscraper::Update
  end

  it "throws an error when accessing updates without a valid project loaded" do
    subject { client.find_project TEST_PROJECT_ID }
    expect { subject.to be_nil }
    expect { subject.updates }.to raise_error
  end

end
