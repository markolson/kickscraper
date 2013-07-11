shared_examples_for "a collection" do |type|
  let(:item) { subject.first }
  
  it { should_not be_empty}

  it "first element is a #{type}" do
    item.should be_a type
    item.name.should_not be_empty if item.respond_to? :name
  end
end
