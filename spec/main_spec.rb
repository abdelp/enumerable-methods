require_relative '../main.rb'

RSpec.describe Enumerable do
  describe '#my_each' do
    subject { array.my_each }
    let(:array) { [1, 2, 3] }
    let(:range) { (1..3) }
    let(:array_of_tuples) { [%i[a b], %i[c d]] }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    # add the same but with a hash (?)

    it 'is expected to return the collection that called the method when a block is given' do
      expect(array.my_each {}).to eq([1, 2, 3])
    end

    # add the same but with a hash (?)

    it { expect { |b| array.my_each(&b) }.to yield_successive_args(1, 2, 3) }
    it { expect { |b| array_of_tuples.my_each(&b) }.to yield_successive_args(%i[a b], %i[c d]) }
    it { expect { |b| { a: 1, b: 2 }.my_each(&b) }.to yield_successive_args([:a, 1], [:b, 2]) }
  end

  describe '#my_each_with_index' do
    subject { array.my_each_with_index }
    let(:array) { [1, 2, 3] }
    let(:range) { (1..3) }
    let(:array_of_tuples) { [%i[a b], %i[c d]] }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return the collection that called the method when a block is given' do
      expect(array.my_each_with_index {}).to eq([1, 2, 3])
    end

    it { expect { |b| array.my_each_with_index(&b) }.to yield_successive_args([1, 0], [2, 1], [3, 2]) }
    it { expect { |b| array_of_tuples.my_each_with_index(&b) }.to yield_successive_args([%i[a b], 0], [%i[c d], 1]) }
    it { expect { |b| { a: 1, b: 2 }.my_each_with_index(&b) }.to yield_successive_args([[:a, 1], 0], [[:b, 2], 1]) }
  end

  describe '#my_all?' do
    subject { array.my_all? }
    let(:array) { [1, 2, 3] }
    let(:param) { Integer }

    it 'is expected to be truthy when none element is false or nil and no block is given' do
      should be_truthy
    end

    it 'is expected to be falsy when at least one element is false or nil and no block is given' do
      expect([true, true, false].my_all?).to be_falsy
    end

    it 'is expected to be truthy when all the elements of the array passes the block condition' do
      expect(array.my_all? { |item| item < 4 }).to be_truthy
    end

    it 'is expected to be falsy when at least one element of the array doesn\'t pass the block condition' do
      expect(array.my_all? { |item| item < 3 }).to be_falsy
    end

    it 'is expected to be truthy on an empty collection' do
      expect([].my_all?).to be_truthy
    end

    # expect to receive all items of the collection of the same type,
    # receive an argument
    # and be truthy

    it 'is expected to be truthy when all the elements of the coleccion has case equality with the parameter given' do
      expect(array.my_all?(param)).to be_truthy
    end
  end
end
