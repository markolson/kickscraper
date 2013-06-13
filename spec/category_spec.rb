describe Kickscraper::Category do
  let(:client) { Kickscraper.client }
  subject { client.categories.first }

  context "loading category info" do
    it { should be_a Kickscraper::Category }
    its(:name) { should_not be_empty }
    its(:projects_count) { should be > 0 }
  end

  context "category urls" do
    subject { client.categories.first.urls}

    it { should_not be_empty }
    its(:api) { should_not be_empty }
  end
end

