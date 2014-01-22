describe Kickscraper::Category do
  let(:client) { Kickscraper.client }
  let(:category) { client.categories.first }

  context "loading category info" do
    subject { category }

    it { should be_a Kickscraper::Category }
    its(:name) { should_not be_empty }
    its(:projects_count) { should be > 0 }
  end

  context "urls" do
    subject { category.urls }

    it { should_not be_empty }
    its(:web) { should_not be_empty }
  end


  context "projects" do
    subject { category.projects }
    it_returns "a collection", Kickscraper::Project
  end
end

