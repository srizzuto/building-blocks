# Module Enumerable
module Enumerable
  def my_each
    i = 0
    while i < size
      yield(at(i))
      i += 1
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      yield(i, at(i))
      i += 1
    end
  end

  def my_select
    selected = []
    my_each { |item| selected << item if yield(item) }
    selected
  end

  def my_all?
    if block_given?
      my_each { |item| return false unless yield(item) }
    else
      my_each { |item| return false unless item }
    end
    true
  end

  def my_any?
    unless empty?
      if block_given?
        my_each { |item| return true if yield(item) }
      else
        my_each { |item| return true if item }
      end
    end
    false
  end

  def my_none?
    unless empty?
      if block_given?
        my_each { |item| return false if yield(item) }
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

  def my_inject(args = 0)
    result = at(args)
    i = args + 1
    while i < size
      result = yield(result, at(i))
      i += 1
    end
    result
  end

  def my_map(args = nil)
    map_array = []
    if block_given?
      my_each { |item| map_array << yield(item) }
      return map_array
    elsif !args.nil?
      my_proc = args
      my_each { |item| map_array << my_proc.call(item) }
      return map_array
    end
    self
  end
end

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end
