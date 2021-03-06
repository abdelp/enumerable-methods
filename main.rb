module Enumerable
  def my_each(&block)
    return to_enum(:my_each) unless block_given?

    i = 0
    while i < length
      if is_a?(Array)
        yield(self[i])
      elsif block.arity == 1
        yield(assoc keys[i])
      else
        yield(keys[i], self[keys[i]])
      end
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    if is_a?(Array)
      items_selected = []
      my_each { |item| items_selected << item if yield(item) }
    else
      items_selected = {}
      my_each { |item, value| items_selected[item] = value if yield(item, value) }
    end
    items_selected
  end

  def my_all?(*args)
    if !args[0].nil?
      my_each { |item| return false unless args[0] === item }
    elsif block_given?
      my_each { |item| return false unless yield(item) }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each { |item| return true if args[0] === item }
    elsif block_given?
      my_each { |item| return true if yield(item) }
    else
      my_each { |item| return true if item }
    end
    false
  end

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(param = nil)
    count = 0

    if !param.nil?
      my_each { |item| count += 1 if item == param }
    elsif block_given?
      my_each { |item| count += 1 if yield(item) }
    else
      my_each { count += 1 }
    end
    count
  end

  def my_map(proc = nil)
    arr = is_a?(Array) ? self : to_a
    result = []

    if !proc.nil?
      arr.my_each { |item| result << proc.call(item) }
    else
      return to_enum(:my_map) unless block_given?

      arr.my_each { |item| result << yield(item) }
    end
    result
  end

  def my_inject(param1 = nil, param2 = nil)
    arr = is_a?(Array) ? self : to_a
    sym = param1 if param1.is_a?(Symbol) || param1.is_a?(String)
    acc = param1 if param1.is_a? Integer

    if param1.is_a?(Integer)
      if param2.is_a?(Symbol) || param2.is_a?(String)
        sym = param2
      elsif !block_given?
        raise "#{param2} is not a symbol nor a string"
      end
    elsif param1.is_a?(Symbol) || param1.is_a?(String)
      raise "#{param2} is not a symbol nor a string" if !param2.is_a?(Symbol) && !param2.nil?

      raise "undefined method `#{param2}' for :#{param2}:Symbol" if param2.is_a?(Symbol) && !param2.nil?
    end

    if sym
      arr.my_each { |curr| acc = acc ? acc.send(sym, curr) : curr }
    elsif block_given?
      arr.my_each { |curr| acc = acc ? yield(acc, curr) : curr }
    else
      raise 'no block given'
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, curr| acc * curr }
end
