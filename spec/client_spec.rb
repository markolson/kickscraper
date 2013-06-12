
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
    
    it "searches projects with a keyword" do
      projects = client.search_projects 'arduino'
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "searches projects for a specific one" do
      projects = client.search_projects 'Spark Core Wi-Fi for Everything'
      projects.length.should be > 0
      projects[0].id.should be 373368980
    end
    
    it "handles searching for projects with special characters" do
      projects = client.search_projects %q{angels & demons with special "characters" and punctuation's n^ight%mare}
      projects.length.should be > 0
    end
    
    it "returns an empty array when searching for projects and finding nothing" do
      projects = client.search_projects "asfakjssdklfjsafajdfklafjdsl"
      projects.should be_an(Array)
      projects.should be_empty
    end
    
    it "finds projects ending soon" do
      projects = client.ending_soon_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds popular projects" do
      projects = client.popular_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds recently launched projects" do
      projects = client.recently_launched_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "finds recently launched projects with the 'newest_projects' method for backwards compatibility" do
      projects = client.newest_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "loads more projects after a successful search" do
      projects = client.recently_launched_projects
      client.can_load_more_projects.should be_true
      
      projects = client.load_more_projects
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "doesn't load more projects after an unsuccessful search" do
      projects = client.search_projects "asfakjssdklfjsafajdfklafjdsl"
      client.can_load_more_projects.should be_false
    end

    it "loads recently launched projects starting at a specific timestamp" do
      projects = client.recently_launched_projects((Time.now - (2 * 24 * 60 * 60)).to_i)
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "loads popular projects starting at a specific set" do
      projects = client.popular_projects(30)
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "loads projects ending soon starting at a specific deadline" do
      projects = client.ending_soon_projects((Time.now + (2 * 24 * 60 * 60)).to_i)
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end
    
    it "searches for projects starting at a specific page of results" do
      projects = client.search_projects('arduino', 2)
      projects.length.should be > 0
      projects[0].should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end

    it "lists all categories" do
      categories = client.categories

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

    it "loads projects in a category from string" do
      category = client.category(TEST_CATEGORY_NAME)
      category.name.should eq TEST_CATEGORY_NAME

      projects = category.projects

      projects.should_not be_empty
      projects.first.should be_a Kickscraper::Project
      projects[0].name.should_not be_empty
    end

  end
  