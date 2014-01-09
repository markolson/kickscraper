shared_examples_for "a collection" do |type|
  let(:item) { subject.first }
  
  it { should_not be_empty}

  it "first element is a #{type}" do
    item.should be_a type
    item.name.should_not be_empty if item.respond_to? :name
  end
end

shared_examples_for "ending_soon projects" do
  context "finds projects ending soon" do
    subject { client.ending_soon_projects }
    it_returns "a collection", Kickscraper::Project
  end
end

shared_examples_for "recently_launched projects" do
  context "finds projects recently lanunched" do
    subject { client.recently_launched_projects}
    it_returns "a collection", Kickscraper::Project
  end

  context "loads more projects after a successful search" do
    subject do
      client.recently_launched_projects
      client.more_projects_available?.should be_true
      client.load_more_projects
    end

    it_returns "a collection", Kickscraper::Project
  end
end 

shared_examples_for "newest_projects projects" do
  context "finds recently launched projects with the 'newest_projects' method for backwards compatibility" do
    subject { client.newest_projects }
    it_behaves_like "recently_launched projects"  
  end
end

shared_examples_for "popular projects" do
  context "finds popular projects" do
    subject { client.popular_projects}
    it_returns "a collection", Kickscraper::Project
  end

  context "loads popular projects starting at a specific page" do
    subject { client.popular_projects(30) }
    it_returns "a collection", Kickscraper::Project
  end
end

shared_examples_for "search projects" do
  context "searches projects with a keyword" do
    subject { client.search_projects 'arduino' }
    it_returns "a collection", Kickscraper::Project
  end
  
  context "searches for projects starting at a specific page of results" do
    subject { client.search_projects('arduino', 2) }
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

  context "doesn't load more projects after an unsuccessful search" do
    before { client.search_projects "asfakjssdklfjsafajdfklafjdsl" }
    its(:more_projects_available?) { should be_false }
  end
end
