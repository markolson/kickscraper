describe Kickscraper::Update do
  let(:client) { Kickscraper.client }
  subject(:update) { client.find_project(TEST_PROJECT_ID).updates.first }

  context "loads basic update information" do
    its(:id) { should be > 0 }
    its(:project_id) { should be > 0 }
    its(:sequence) { should be > 0 }
    its(:public) { should satisfy { |s| [true,false].include?(s) } }
    its(:visible) { should satisfy { |s| [true,false].include?(s) } }
    its(:title) { should_not be_empty }
    its(:published_at) { should be >= 1262304000 }
    its(:updated_at) { should be >= 1262304000 }
    its(:comments_count) { should be >= 0 }
    its(:likes_count) { should be >= 0 }
  end

  context "reloads" do
    before { update.reload! }

    its(:sequence) { should be > 0 }
    its(:title) { should_not be_empty }
  end

  context "loads additional information for a visible update" do
    # Ensure that this test runs on a public update, so its success does not
    # depend on the user running the tests
    subject { client.process_api_url("update", TEST_PUBLIC_UPDATE_URL) }

    its(:body) { should_not be_empty }
    its(:images) { should have_at_least(0).items } 
    its(:sounds) { should have_at_least(0).items } 
  end
end