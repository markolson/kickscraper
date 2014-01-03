describe Kickscraper::Client do
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
    
    describe ".find_user" do
      subject(:user) { client.find_user TEST_USER_ID }

      it { should be_nil } # don't know how to do on purely Public API
    end

    describe ".find_product" do
      subject(:project) { client.find_project TEST_PROJECT_ID }

      it { should be_nil } # don't know how to do on purely Public API
    end
    
    describe ".categories" do
      subject { client.categories }

      it { should eq [] } # don't know how to do on purely Public API
    end

    describe ".category" do
      context "loads a category from string" do
        subject { client.category(TEST_CATEGORY_NAME) }

        it { should be_nil } # don't know how to do on purely Public API
      end

      context "loads a category from an id" do
        subject { client.category(TEST_CATEGORY_ID) }

        it { should be_nil } # don't know how to do on purely Public API
      end
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
  end 
end 
