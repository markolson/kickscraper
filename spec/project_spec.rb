describe Kickscraper::Project do
  let(:client) { Kickscraper.client }
  subject (:project) { client.find_project TEST_PROJECT_ID }

  it "loads all info for a project" do
    project.id.should be > 0
    project.name.should_not be_empty
    project.launched_at.should be >= 1262304000
    project.blurb.should_not be_empty
    project.photo.length.should be > 0
    project.goal.should be > 0
    project.creator.should be_a Kickscraper::User
    project.pledged.should be >= 0
    project.created_at.should be >= 1262304000
    project.slug.should_not be_empty
    project.deadline.should be >= 1262304000
    (project.active?.is_a?(TrueClass) || project.active?.is_a?(FalseClass)).should be_true
    (project.successful?.is_a?(TrueClass) || project.successful?.is_a?(FalseClass)).should be_true
    project.category.should be_a Kickscraper::Category
    project.video.length.should be > 0
    project.rewards.length.should be > 0
  end
  
  it "reloads" do
    project.reload!
    
    project.id.should == TEST_PROJECT_ID
    project.name.should == TEST_PROJECT_NAME
    project.creator.should be_a Kickscraper::User
  end
  
  it "loads comments that must be called by a separate API call" do
    projects = client.popular_projects
    project = projects[0]

    comments = project.comments
    comments.length.should be >= 0
    if comments.length > 0 then comments[0].should be_a Kickscraper::Comment end
  end

  it "loads updates that must be called by a separate API call" do
    projects = client.popular_projects
    project = projects[0]
    
    updates = project.updates
    updates.length.should be >= 0
    if updates.length > 0 then updates[0].should be_a Kickscraper::Update end
  end
  
  it "loads the rewards for a project that was brought in through a different API call" do
    projects = client.recently_launched_projects
    project = projects[0]
    
    rewards = project.rewards
    rewards.length.should be > 0
  end
end
