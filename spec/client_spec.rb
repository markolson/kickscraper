
  describe Kickscraper::Client do
    let(:client) { Kickscraper.client }
    
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

    it "lists all categories" do
      categories = @c.categories

      categories.should_not be_empty
      categories[0].should be_a Kickscraper::Category
      categories[0].name.should_not be_empty
    end

    it "loads projects in a category from string" do
      category = client.category(TEST_CATEGORY_NAME)
      category.name.should eq TEST_CATEGORY_NAME

      projects = category.projects

      projects.should_not be_empty
      projects.first.should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
  end
  