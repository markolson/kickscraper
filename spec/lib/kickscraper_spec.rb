require_relative '../../lib/kickscraper.rb'


describe Kickscraper do
  
  before(:all) do
    
    # configure kickscraper before the tests
    # (put your real kickstarter API credentials here)
    KICKSCRAPER_TEST_API_EMAIL = 'your_kickstarter_email'
    KICKSCRAPER_TEST_API_PASSWORD = 'your_kickstarter_password'
    
    
    # if you want to use a proxy (like Charles, etc) to capture
    # data for debugging, set it here
    #LOCAL_PROXY = 'https://localhost:8888'
    
    
    # define some test contants
    TEST_USER_ID = 1869987317
    TEST_PROJECT_ID = 1871494789
    TEST_PROJECT_SLUG = 'wish-i-was-here-1'
    TEST_PROJECT_NAME = "WISH I WAS HERE"
    
    
    # initialize kickscraper
    Kickscraper.configure do |config|
      config.email = KICKSCRAPER_TEST_API_EMAIL
      config.password = KICKSCRAPER_TEST_API_PASSWORD
      config.proxy = LOCAL_PROXY if defined? LOCAL_PROXY
    end
    
  end
  
  
  it "accepts configuration" do
    Kickscraper.email.should == KICKSCRAPER_TEST_API_EMAIL
  end
  
  it "connects to the kickstarter api" do
    c = Kickscraper.client
    
    c.should_not be_nil
    c.should be_a Kickscraper::Client
    
    c.user.should_not be_nil
    c.user.id.should be > 0
  end
  
  
  describe Kickscraper::Client do
    
    before(:all) do
      @c = Kickscraper.client
    end
    
    it "finds a user by id" do
      user = @c.find_user TEST_USER_ID
      
      user.id.should == TEST_USER_ID
      user.name.should == 'Zach Braff'
    end
    
    it "returns nil when finding a non-existent user" do
      user = @c.find_user 9999
      user.should be_nil
    end
    
    it "finds a project by id" do
      project = @c.find_project TEST_PROJECT_ID
      
      project.id.should == TEST_PROJECT_ID
      project.slug.should == TEST_PROJECT_SLUG
      project.name.should == TEST_PROJECT_NAME
    end
    
    it "finds a project by slug" do
      project = @c.find_project TEST_PROJECT_SLUG
      
      project.id.should == TEST_PROJECT_ID
      project.slug.should == TEST_PROJECT_SLUG
      project.name.should == TEST_PROJECT_NAME
    end
    
    it "returns nil when finding a non-existent project" do
      project = @c.find_project 9999
      project.should be_nil
    end
    
    it "searches projects with a keyword" do
      projects = @c.search_projects 'arduino'
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "searches projects for a specific one" do
      projects = @c.search_projects 'Spark Core Wi-Fi for Everything'
      projects.length.should be > 0
      projects[0].id.should be 373368980
    end
    
    it "handles searching for projects with special characters" do
      projects = @c.search_projects %q{angels & demons with special "characters" and punctuation's n^ight%mare}
      projects.length.should be > 0
    end
    
    it "returns an empty array when searching for projects and finding nothing" do
      projects = @c.search_projects "asfakjssdklfjsafajdfklafjdsl"
      projects.should be_an(Array)
      projects.should be_empty
    end
    
    it "finds projects ending soon" do
      projects = @c.ending_soon_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds popular projects" do
      projects = @c.popular_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds recently launched projects" do
      projects = @c.recently_launched_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds recently launched projects with the 'newest_projects' method for backwards compatibility" do
      projects = @c.newest_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "loads more projects after a successful search" do
      projects = @c.recently_launched_projects
      @c.can_load_more_projects.should be_true
      
      projects = @c.load_more_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "doesn't load more projects after an unsuccessful search" do
      projects = @c.search_projects "asfakjssdklfjsafajdfklafjdsl"
      @c.can_load_more_projects.should be_false
    end
  end
  
  
  describe Kickscraper::User do
    
    before(:all) do
      @c = Kickscraper.client
      @user = @c.find_user TEST_USER_ID
    end
    
    it "loads all info for a user" do
      @user.id.should be > 0
      @user.name.should_not be_empty
      @user.avatar.length.should be > 0
      @user.biography.should_not be_empty
      @user.backed_projects_count.should_not be_nil
      @user.created_at.should be > 1262304000
      
      backed_projects = @user.backed_projects
      backed_projects.length.should be >= 0
      if backed_projects.length > 0 then backed_projects[0].should be_a Kickscraper::Project end
      
      starred_projects = @user.starred_projects
      starred_projects.length.should be >= 0
      if starred_projects.length > 0 then starred_projects[0].should be_a Kickscraper::Project end
    end
    
    it "reloads" do
      @user.reload!
      
      @user.id.should == TEST_USER_ID
      @user.name.should == 'Zach Braff'
    end
    
    it "loads the biography for a user that was brought in through a different API call" do
      project = @c.find_project TEST_PROJECT_ID
      user = project.creator
      user.biography.should_not be_empty
    end
  end
  
  
  describe Kickscraper::Project do
    
    before(:all) do
      @c = Kickscraper.client
      @project = @c.find_project TEST_PROJECT_ID
    end
    
    it "loads all info for a project" do
      @project.id.should be > 0
      @project.name.should_not be_empty
      @project.launched_at.should be >= 1262304000
      @project.blurb.should_not be_empty
      @project.photo.length.should be > 0
      @project.goal.should be > 0
      @project.creator.should be_a Kickscraper::User
      @project.pledged.should be >= 0
      @project.created_at.should be >= 1262304000
      @project.slug.should_not be_empty
      @project.deadline.should be >= 1262304000
      (@project.active?.is_a?(TrueClass) || @project.active?.is_a?(FalseClass)).should be_true
      (@project.successful?.is_a?(TrueClass) || @project.successful?.is_a?(FalseClass)).should be_true
      @project.category.should be_a Kickscraper::Category
      @project.video.length.should be > 0
      @project.rewards.length.should be > 0
    end
    
    it "reloads" do
      @project.reload!
      
      @project.id.should == TEST_PROJECT_ID
      @project.name.should == TEST_PROJECT_NAME
      @project.creator.should be_a Kickscraper::User
    end
    
    it "loads all the extra info that must be called by a separate API call" do
      comments = @project.comments
      comments.length.should be >= 0
      if comments.length > 0 then comments[0].should be_a Kickscraper::Comment end
      
      updates = @project.updates
      updates.length.should be >= 0
      if updates.length > 0 then updates[0].should be_a Kickscraper::Update end
    end
    
    it "loads the rewards for a project that was brought in through a different API call" do
      projects = @c.recently_launched_projects
      project = projects[0]
      
      rewards = project.rewards
      rewards.length.should be > 0
    end
  end
end