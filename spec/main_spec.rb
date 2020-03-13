require_relative '../main.rb'

RSpec.describe Enumerable do

  describe "#my_each" do
    subject { array.my_each }
    let(:array) { [1, 2, 3] }
    let(:range) { (1..3) }
    let(:array_of_tuples) {[[:a, :b], [:c, :d]]}

    it "is expected to return an enumerator when no block is given" do
      should be_kind_of(Enumerator)
    end

    it { expect { |b| array.my_each(&b) }.to yield_successive_args(1, 2, 3) }
    it { expect { |b| array_of_tuples.my_each(&b) }.to yield_successive_args([:a, :b], [:c, :d]) }
    it { expect { |b| { :a => 1, :b => 2 }.my_each(&b) }.to yield_successive_args([:a, 1], [:b, 2]) }
    it { expect { |b| array.my_each(&b) }.to yield_successive_args(Integer, Integer, Integer) }
  end

end