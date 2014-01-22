describe Kickscraper::Project do
  context "no email no password client" do
    before(:all) do
      @save_token = Kickscraper.token
      Kickscraper.token=nil
    end
  
    after (:all) do
      Kickscraper.token=@save_token
    end
  
    let(:client) do
      Kickscraper.configure do |config|
        config.email = nil
        config.password = nil
      end
      Kickscraper::Client.new
    end
    subject (:project) { client.recently_launched_projects[0]}


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
      project.video.should be_nil
      project.rewards.should be_nil
    end
  
    it "reloads" do
      save_id = project.id
      save_name = project.name 

      project.reload!
      
      project.id.should == save_id
      project.name.should == save_name
      project.creator.should be_a Kickscraper::User
    end
    
    it "loads empty array for comments that depend on user being looged in and called by a separate API call" do
      projects = client.popular_projects
      project = projects[0]

      comments = project.comments
      comments.length.should be == 0
    end

    it "loads empty array for updates that depend on user being looged in and called by a separate API call" do
      projects = client.popular_projects
      project = projects[0]

      updates = project.updates
      updates.length.should be == 0
    end

      
    it "does not load the rewards for a project brought in thru public call" do
      projects = client.recently_launched_projects
      project = projects[0]

      project.rewards.should be_nil
    end
  end 
end 
