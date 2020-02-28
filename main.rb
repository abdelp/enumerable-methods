# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    to_enum(:my_each) unless block_given?

    i = 0
    while i < length
      yield(self[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    to_enum(:my_each_with_index) unless block_given?

    i = 0
    while i < length
      yield(self[i], i)
      i += 1
    end
    self
  end

  def my_select
    to_enum(:my_select) unless block_given?

    items_selected = []
    my_each { |item| items_selected << item if yield(item) }
    items_selected = items_selected.to_h if is_a?(Hash)
    items_selected
  end

  def my_all?(*args)
    if !args[0].nil?
      my_each { |item| return false unless item.is_a?(args[0]) }
    elsif block_given?
      my_each { |item| return false unless yield(item) }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  def my_any?(*args)
    if !args[0].nil?
      my_each { |item| return true if item.is_a?(args[0]) }
    elsif block_given?
      my_each { |item| return true if yield(item) }
    else
      my_each { |item| return true if item }
    end
    false
  end

  def my_none?(*args)
    if !args[0].nil?
      my_each { |item| return false if item.is_a?(args[0]) }
    elsif block_given?
      my_each { |item| return false if yield(item) }
    else
      my_each { |item| return false if item }
    end
    true
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

  def my_map(*proc)
    arr = []

    if !proc.empty?
      my_each { |item| arr << proc.call(item) }
    else
      to_enum(:my_map) unless block_given?
      my_each { |item| arr << yield(item) }
    end
    arr
  end

  def my_inject(param1 = nil, param2 = nil)
    sym = param1 if param1.is_a?(Symbol) || param1.is_a?(String)
    acc = param1 if param1.is_a? Integer

    if param1.is_a? Integer
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
      my_each { |curr| acc = acc ? acc.send(sym, curr) : curr }
    elsif block_given?
      my_each { |curr| acc = acc ? yield(acc, curr) : curr }
    else
      raise 'no block given'
    end
    acc
  end
end

def multiply_els(arr)
  arr.my_inject { |acc, curr| acc * curr }
end

# proc = Proc.new {|x| x * 2}

# def foo(*proc)
#   p "is not a proc"
#   p "#{(proc).class}"
#   p "#{proc}"
#   if proc.is_a?(Proc)
#     p "is a proc"
#     [1,2,3].each{|x| proc.call(x)}
#   end
# end

# foo(&proc)
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
