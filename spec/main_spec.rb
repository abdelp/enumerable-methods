require_relative '../main.rb'

RSpec.describe Enumerable do
  let(:numbers) { (-10..10).to_a }
  let(:hash) { { a: :b, c: :d } }
  let(:array_of_tuples) { [%i[a b], %i[c d]] }

  describe '#my_each' do
    subject { numbers.my_each }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return the collection that called the method when a block is given' do
      expect(numbers.my_each {}).to eq(numbers)
    end

    it 'is expected to return the hash collection that called the method when a block is given' do
      expect(hash.my_each {}).to eq(hash)
    end

    it { expect { |b| numbers.my_each(&b) }.to yield_successive_args(*numbers) }
    it { expect { |b| array_of_tuples.my_each(&b) }.to yield_successive_args(*array_of_tuples) }
    it { expect { |b| hash.my_each(&b) }.to yield_successive_args(*hash.to_a) }
  end

  describe '#my_each_with_index' do
    subject { numbers.my_each_with_index }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return the collection that called the method when a block is given' do
      expect(numbers.my_each_with_index {}).to eq(numbers)
    end

    it { expect { |b| numbers.my_each_with_index(&b) }.to yield_successive_args([1, 0], [2, 1], [3, 2]) }
    it { expect { |b| array_of_tuples.my_each_with_index(&b) }.to yield_successive_args([%i[a b], 0], [%i[c d], 1]) }
    it { expect { |b| { a: 1, b: 2 }.my_each_with_index(&b) }.to yield_successive_args([[:a, 1], 0], [[:b, 2], 1]) }
  end

  describe '#my_select' do
    subject { array.my_select }
    let(:array) { [1, 2, 3] }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return an array with all of the elements matching the block condition' do
      expect(array.my_select { |item| item == 1 }).to eq([1])
    end
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

    it 'is expected to be truthy when all the elements of the coleccion has case equality with the parameter given' do
      expect(array.my_all?(param)).to be_truthy
    end
  end

  describe '#my_any?' do
    subject { array.my_any? }
    let(:array) { [1, false, nil] }
    let(:param) { Integer }

    it 'is expected to be truthy when any element in the collection is truthy and no block nor parameter is given' do
      should be_truthy
    end

    it 'is expected to be truthy when at least one of the elements in the collection passes the block condition' do
      expect(array.my_any? { |item| item == 1 }).to be_truthy
    end

    it 'is expected to be falsy on an empty collection' do
      expect([].my_any?).to be_falsy
    end

    it 'is expected to be truthy when any element of the coleccion has case equality with the parameter given' do
      expect(array.my_any?(param)).to be_truthy
    end
  end

  describe '#my_none?' do
    subject { falsies.my_none? }
    let(:falsies) { [false, false, false] }
    let(:truthies) { [true, true, true] }
    let(:mixed) { [true, false, nil, 1, 'a', :x] }
    let(:hash) { { val: 1, heigth: 2 } }
    let(:param) { false }

    it 'is expected to be truthy when all elements in the collection are falsy and no block nor parameter is given' do
      should be_truthy
    end

    it 'is expected to be falsy when any element in the collection is truthy and no block nor parameter is given' do
      expect(mixed.my_none?).to be_falsy
    end

    it 'is expected to be truthy when all the elements in the collection doens\'t pass the block condition' do
      expect(falsies.my_none? { |item| item == true }).to be_truthy
    end

    it 'is expected to be falsy when any of the elements in the collection pass the block condition' do
      expect(mixed.my_none? { |item| item == true }).to be_falsy
    end

    it 'is expected to be falsy on an empty collection' do
      expect([].my_none?).to be_truthy
    end

    it 'is expected to be truthy when none element of the coleccion has case equality with the parameter given' do
      expect(falsies.my_none?(true)).to be_truthy
    end

    it 'is expected to be falsy when any element of the coleccion has case equality with the parameter given' do
      expect(mixed.my_none?(false)).to eq(false)
    end

    it 'is expected to be truthy if all attributes in a hash doens\'t pass the block condition' do
      expect(truthies.my_none? { |item| item == false })
    end

    it 'is expected to be falsy if any attribute in a hash pass the block condition' do
      expect(mixed.my_none? { |item| item == false })
    end
  end

  describe '#my_count' do
    subject { array.my_any? }
    let(:array) { [1, 2, 3] }

    it 'is expected to return the number of elements in a collection when none block nor parameter is give' do
      expect(array.my_count).to eq(array.size)
    end

    it 'is expected to return the number of elements in the collection matching the given parameter' do
      expect(array.my_count(1)).to eq(1)
    end

    it 'is expected to return the number of elements in the collection matching the block condition' do
      expect(array.my_count { |item| item == 1 }).to eq(1)
    end

    it 'is expected to ignore given block if an argument was given' do
      expect(array.my_count(1) { |item| item > 1 }).to eq(1)
    end
  end

  describe '#my_map' do
    subject { array.my_map }
    let(:array) { [1, 2, 3] }
    let(:hash) { { val: 1, heigth: 2 } }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return an array with results of running block once for every element in the collection' do
      expect(array.my_map { |item| item * 2 }).to eq([2, 4, 6])
    end

    it 'is expected to return an array with results of running block once for every hash attribute' do
      expect(hash.my_map { |item| item }).to eq([[:val, 1], [:heigth, 2]])
    end
  end

  describe '#my_inject' do
    subject { array.my_inject }
    let(:array) { [1, 2, 3] }

    it 'is expected to return to combination of all elements in the collection with the given binary operator string' do
      expect(array.my_inject('+')).to eq(6)
    end

    it 'is expected to return to combination of all elements in the collection with the given binary operator symbol' do
      expect(array.my_inject(:+)).to eq(6)
    end

    it 'is expected to receive the first argument as initial value and the second one as the binary operator' do
      expect(array.my_inject(1, :+)).to eq(7)
    end

    it 'is expected to combine the elements acording to the block given' do
      expect(array.my_inject { |acc, curr| acc + curr }).to eq(6)
    end

    it 'is expected to combine the elements acording to the block given and the argument as initial value' do
      expect(array.my_inject(1) { |acc, curr| acc + curr }).to eq(7)
    end
  end
end
