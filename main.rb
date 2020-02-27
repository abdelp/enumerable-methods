module Enumerable
  def my_each
    return enum_for(:my_each) unless block_given?

    (0..length - 1).each do |i|
      yield(self[i])
    end
    self
  end

  def my_each_with_index
    return enum_for(:my_each_with_index) unless block_given?

    (0..length - 1).each do |i|
      yield(self[i], i)
    end
    self
  end

  def my_select
    return enum_for(:my_select) unless block_given?

    items_selected = []

    my_each do |item|
      items_selected << item if yield(item)
    end
    items_selected
  end

  def my_all?(*args)
    if !args[0].nil?
      my_each do |item|
        return false unless args[0] === item
      end
    elsif block_given?
      my_each do |item|
        return false unless yield(item)
      end
    else
      my_each do |item|
        return false unless item
      end
    end
    true
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each do |item|
        return true if args[0] === item
      end
    elsif block_given?
      my_each do |item|
        return true if yield(item)
      end
    else
      my_each do |item|
        return true if item
      end
    end
    false
  end

  def my_none?(*args)
    if !args[0].nil?
      my_each do |item|
        return false if args[0] === item
      end
    elsif block_given?
      my_each do |item|
        return false if yield(item)
      end
    else
      my_each do |item|
        return false if item
      end
    end
    true
  end

  def my_count(p1 = nil)
    count = 0

    if !p1.nil?
      my_each do |item|
        count += 1 if item == p1
      end
    elsif block_given?
      my_each do |item|
        count += 1 if yield(item)
      end
    else
      my_each do |_item|
        count += 1
      end
    end
    count
  end

  def my_map
    return enum_for(:my_map) unless block_given?

    arr = []
    my_each do |item|
      arr << yield(item)
    end
    arr
  end

  def my_inject(p1 = nil, p2 = nil)
    sym = nil
    acc = nil

    if p1.is_a? Integer
      acc = p1
      if p2.is_a?(Symbol) || p2.is_a?(String)
        sym = p2
      elsif !block_given?
        raise "#{p2} is not a symbol nor a string"
      end
    elsif p1.is_a?(Symbol)
      sym = p1
      if !p2.is_a?(Symbol) && !p2.nil?
        raise "#{p2} is not a symbol nor a string"
      elsif p2.is_a?(Symbol) && !p2.nil?
        raise "undefined method `#{p2}' for :#{p2}:Symbol"
      end
    end

    if sym
      my_each do |curr|
        acc = acc ? acc.send(sym, curr) : curr
      end
    elsif block_given?
      my_each do |curr|
        acc = acc ? yield(acc, curr) : curr
      end
    else
      raise 'no block given'
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, curr| acc * curr }
end
