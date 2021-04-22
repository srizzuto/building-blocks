# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
# frozen_string_literal: true

# Module Enumerable
module Enumerable
  def my_each
    i = 0
    return enum_for unless block_given?

    arr = to_a
    while i < arr.size
      yield(arr.at(i))
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    return enum_for unless block_given?

    arr = to_a if is_a?(Range) || is_a?(Hash)
    while i < arr.size
      yield(arr.at(i), i)
      i += 1
    end
    self
  end

  def my_select
    return enum_for unless block_given?

    selected = []
    my_each { |item| selected << item if yield(item) }
    selected
  end

  def my_all?(args = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
    elsif args.nil?
      my_each { |item| return false if item.nil? || item == false }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |item| return false if item.class != args }
    elsif !args.nil? && instance_of?(Hash)
      return false unless empty?
    elsif !args.nil? && args.instance_of?(Regexp)
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
        my_each { |item| return true if item.instance_of?(args) }
      elsif !args.nil? && instance_of?(Hash)
        return false unless empty?
      elsif !args.nil? && args.instance_of?(Regexp)
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
        my_each { |item| return false if item.instance_of?(args) }
      elsif !args.nil? && args.instance_of?(Regexp)
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

  def my_inject(num = 0, sym = nil)
    result = num
    unless block_given?
      if num.instance_of?(Symbol) || num.instance_of?(String)
        result = 0
        my_each { |item| result = item.send(num, result) }
      elsif !sym.nil? && sym.instance_of?(Symbol)
        my_each { |item| result = item.send(sym, result) }
      end
      return result
    end
    return  to_a if is_a?(Hash)

    my_each { |item| result = yield(result, item) }
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
    end
    enum_for
  end
end

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end
