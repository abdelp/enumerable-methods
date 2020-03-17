require_relative '../main.rb'

RSpec.describe Enumerable do
  let(:numbers) { (-10..10).to_a }
  let(:numbers_idx) { (-10..10).to_a.map.with_index { |a, i| [a, i] } }
  let(:hash) { { a: :b, c: :d } }
  let(:hash_idx) { { a: :b, c: :d }.to_a.map.with_index { |k, v| [k, v] } }
  let(:array_of_tuples) { [%i[a b], %i[c d]] }
  let(:array_of_tuples_idx) { [%i[a b], %i[c d]].map.with_index { |k, v| [k, v] } }
  let(:truthies) { [true, 1, 'a'] }
  let(:falsies) { [false, nil] }
  let(:mixed) { truthies + falsies }

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

    it { expect { |b| numbers.my_each_with_index(&b) }.to yield_successive_args(*numbers_idx) }
    it { expect { |b| array_of_tuples.my_each_with_index(&b) }.to yield_successive_args(*array_of_tuples_idx) }
    it { expect { |b| hash.my_each_with_index(&b) }.to yield_successive_args(*hash_idx) }
  end

  describe '#my_select' do
    subject { numbers.my_select }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return an array with all of the elements matching the block condition' do
      expect(numbers.my_select { |item| item == 1 }).to eq([1])
    end
  end

  describe '#my_all?' do
    subject { truthies.my_all? }
    let(:param) { Integer }

    it 'is expected to be truthy when none element is false or nil and no block is given' do
      should be_truthy
    end

    it 'is expected to be falsy when at least one element is false or nil and no block is given' do
      expect(mixed.my_all?).to be_falsy
    end

    it 'is expected to be truthy when all the elements of the array passes the block condition' do
      expect(numbers.my_all? { |item| item < 11 }).to be_truthy
    end

    it 'is expected to be falsy when at least one element of the array doesn\'t pass the block condition' do
      expect(numbers.my_all? { |item| item < 3 }).to be_falsy
    end

    it 'is expected to be truthy on an empty collection' do
      expect([].my_all?).to be_truthy
    end

    it 'is expected to be truthy when all the elements of the coleccion has case equality with the parameter given' do
      expect(numbers.my_all?(param)).to be_truthy
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
    subject { numbers.my_any? }

    it 'is expected to return the number of elements in a collection when none block nor parameter is give' do
      expect(numbers.my_count).to eq(numbers.size)
    end

    it 'is expected to return the number of elements in the collection matching the given parameter' do
      expect(numbers.my_count(1)).to eq(1)
    end

    it 'is expected to return the number of elements in the collection matching the block condition' do
      expect(numbers.my_count { |item| item == 1 }).to eq(1)
    end

    it 'is expected to ignore given block if an argument was given' do
      expect(numbers.my_count(1) { |item| item > 1 }).to eq(1)
    end
  end

  describe '#my_map' do
    subject { numbers.my_map }

    it 'is expected to return an enumerator when no block is given' do
      should be_kind_of(Enumerator)
    end

    it 'is expected to return an array with results of running block once for every element in the collection' do
      expect(numbers.my_map { |item| item * 2 }).to eq(numbers.map { |item| item * 2 })
    end

    it 'is expected to return an array with results of running block once for every hash attribute' do
      expect(hash.my_map { |item| item }).to eq(hash.to_a)
    end
  end

  describe '#my_inject' do
    subject { numbers.my_inject }

    it 'is expected to return to combination of all elements in the collection with the given binary operator string' do
      expect(numbers.my_inject('+')).to eq(numbers.inject('+'))
    end

    it 'is expected to return to combination of all elements in the collection with the given binary operator symbol' do
      expect(numbers.my_inject(:+)).to eq(numbers.inject(:+))
    end

    it 'is expected to receive the first argument as initial value and the second one as the binary operator' do
      expect(numbers.my_inject(1, :+)).to eq(numbers.inject(1, :+))
    end

    it 'is expected to combine the elements acording to the block given' do
      expect(numbers.my_inject { |acc, curr| acc + curr }).to eq(numbers.inject { |acc, curr| acc + curr })
    end

    it 'is expected to combine the elements acording to the block given and the argument as initial value' do
      expect(numbers.my_inject(1) { |acc, curr| acc + curr }).to eq(numbers.inject(1) { |acc, curr| acc + curr })
    end
  end
end
