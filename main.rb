# Module Enumerable
module Enumerable
  def my_each
    i = 0
    unless block_given? then return enum_for end
    arr = to_a 
    while i < arr.size
      yield(arr.at(i))
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    unless block_given? then return enum_for end
    arr = to_a if is_a? Range or is_a? Hash
    while i < arr.size
      yield(arr.at(i), i)
      i += 1
    end
    self
  end

  def my_select
    unless block_given? then return enum_for end
    selected = []
    my_each { |item| selected << item if yield(item) }
    selected
  end

  def my_all?(args = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
      return true
    elsif args.nil?
      my_each { |item| return false if item.nil? || item == false }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |item| return false if item.class != args }
    elsif !args.nil? && self.class == Hash
      return false unless empty? 
    elsif !args.nil? && args.class == Regexp
      my_each { |item| return false unless args.match(item.to_s) }
    else
      my_each { |item| return false if item != args }
    end
    true
  end

  def my_any?(args = nil)
    arr = to_a 
    unless arr.empty?
      if block_given?
        my_each { |item| return true if yield(item) }
      elsif !args.nil? && (args.is_a? Class)
        my_each { |item| return true if item.class == args }
      elsif !args.nil? && self.class == Hash
        return false unless empty? 
      elsif !args.nil? && args.class == Regexp
        my_each { |item| return true if args.match(item.to_s) }
      elsif args.nil?
        my_each { |item| return true if item == args }
      else
        my_each { |item| return true if item }
      end
    end
    false
  end

  def my_none?(args = nil)
    arr = to_a 
    unless arr.empty?
      if block_given?
        my_each { |item| return false if yield(item) }
      elsif !args.nil? && (args.is_a? Class)
        my_each { |item| return false if item.class == args } 
      elsif !args.nil? && args.class == Regexp
        my_each { |item| return false if args.match(item.to_s) }
      elsif !args.nil?
        my_each { |item| return false if item == args }
      else
        my_each { |item| return false if item }
      end
    end
    true
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      my_each { |item| counter += 1 if yield(item) }
      return counter
    elsif !args.nil?
      my_each { |item| counter += 1 if item == args }
      return counter
    end
    size
  end

  def my_inject(n = 0, s = nil)
    arr = to_a
    i = 0
    result = n
    unless block_given?
      if n.class == Symbol or n.class == String 
        result = 0
        my_each { |item| result = item.send(n, result) }
      elsif !s.nil? && s.class == Symbol
        my_each { |item| result = item.send(s, result) }
      end
      return result
    end
    while i < arr.size
      result = yield(result, arr.at(i))
      i += 1
    end
    result
  end

  def my_map(args = nil)
    map_array = []
    if !args.nil? 
      my_proc = args
      my_each { |item| map_array << my_proc.call(item) }
      return map_array
    elsif block_given?
      my_each { |item| map_array << yield(item) }
      return map_array
    else
      return enum_for
    end
    self
  end
end

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end

puts (1..5).inject(2,:+)
puts (1..5).my_inject(2,:+)