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
  
  
  describe "Client" do
    
    before(:all) do
      @c = Kickscraper.client
    end
    
    it "finds a user by id" do
      user = @c.find_user TEST_USER_ID
      
      user.id.should == TEST_USER_ID
      user.name.should == 'Zach Braff'
    end
    
    it "handles finding a non-existent user" do
      user = @c.find_user 9999
      user.should be_nil
    end
    
    it "finds a project by id" do
      project = @c.find_project TEST_PROJECT_ID
      
      project.id.should == TEST_PROJECT_ID
      project.slug.should == TEST_PROJECT_SLUG
      project.name.should == "WISH I WAS HERE"
    end
    
    it "finds a project by slug" do
      project = @c.find_project TEST_PROJECT_SLUG
      
      project.id.should == TEST_PROJECT_ID
      project.slug.should == TEST_PROJECT_SLUG
      project.name.should == "WISH I WAS HERE"
    end
    
    it "handles finding a non-existent project" do
      project = @c.find_project 9999
      project.should be_nil
    end
    
    it "searches projects with a keyword" do
      projects = @c.search_projects 'arduino'
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
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
    
    it "handles searching for projects and finding nothing" do
      projects = @c.search_projects "asfakjssdklfjsafajdfklafjdsl"
      projects.should be_an(Array)
      projects.should be_empty
    end
  end
  
  
  describe "User" do
    
    before(:all) do
      @c = Kickscraper.client
      @user = @c.find_user TEST_USER_ID
    end
    
    it "reloads a user" do
      @user.reload!
      
      @user.id.should == TEST_USER_ID
      @user.name.should == 'Zach Braff'
    end
    
    it "loads all info for a user" do
      @user.avatar.should_not be_empty
      @user.biography.should_not be_empty
      @user.backed_projects_count.should_not be_nil
      @user.created_at.should be > 0
      
      backed_projects = @user.backed_projects
      backed_projects.length.should be >= 0
      if backed_projects.length > 0 then backed_projects[0].should be_a Kickscraper::Project end
      
      starred_projects = @user.starred_projects
      starred_projects.length.should be >= 0
      if starred_projects.length > 0 then starred_projects[0].should be_a Kickscraper::Project end
    end
  end
  
  
  describe "Project" do
    
    before(:all) do
      @c = Kickscraper.client
      @project = @c.find_project TEST_PROJECT_ID
    end
    
  end
end