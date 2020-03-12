require_relative '../main.rb'

RSpec.describe Enumerable do
  
  describe "#my_each" do
    subject { arr.my_each }
    let(:arr) { [1, 2, 3] }

    it "returns an enumerator when it doesn't receive a block" do
      should be_kind_of(Enumerator)
    end

    it "returns "
  end
end