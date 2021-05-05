# frozen_string_literal: true

# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

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

  def my_each_with_index(args = nil)
    i = 0
    arr = to_a
    return enum_for unless block_given?

    if args.nil?
      while i < arr.size
        yield(arr.at(i), i)
        i += 1
      end
      return self
    end
    my_proc = args
    while i < arr.size
      my_proc.call(arr.at(i), i)
      i += 1
    end
    self
  end

  def my_select
    return enum_for unless block_given?

    new_arr = []
    new_hash = {}
    my_each do |k, v|
      if instance_of?(Hash)
        new_hash.store(k, v) if yield(k, v)
      elsif yield(k, v) == true
        new_arr << k if yield(k) == true
      end
    end
    instance_of?(Hash) ? new_hash : new_arr
  end

  def my_all?(args = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
    elsif args.nil?
      my_each { |item| return false if item.nil? || item == false }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |item| return false if item.class != args && item.class.superclass != args }
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
      elsif !args.nil? && (args.is_a? String)
        my_each { |item| return true if item == args }
      elsif !args.nil? && (args.is_a? Class)
        my_each { |item| return true if item.instance_of?(args) || (item.class.superclass == args) }
      elsif !args.nil? && instance_of?(Hash)
        return false unless empty?
      elsif !args.nil? && args.instance_of?(Regexp)
        my_each { |item| return true if args.match(item.to_s) }
      else
        my_each { |item| return true if item }
      end
    end
    false
  end

  def my_none?(*args)
    if block_given?
      my_each { |item| return false if yield(item) } == self
    elsif args.empty?
      if empty?
        true
      else
        my_each do |item|
          return false unless item.nil? || (item == false)
        end == self
      end
    else
      my_each { |item| return false if item.is_a?(*args) } == self if args[0].instance_of?(Class)
      my_each { |item| return false if item.to_s.match(args[0]) } == self if args[0].instance_of?(Regexp)
      my_each { |item| return false if item == args[0] } == self
    end
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

  def my_inject(*args)
    if block_given? == false
      raise LocalJumpError, 'no block given' if args.empty?

      accu = args.size < 2 ? to_a[0] : args[0]
      to_a.my_each_with_index do |_v, i|
        accu = accu.send(args[0], to_a[i + 1]) if args.size < (2) && !to_a[i + 1].nil?
        accu = accu.send(args[1], to_a[i]) if args.size >= 2
      end
    else
      accu = args.empty? ? to_a[0] : args[0]
      my_each_with_index { |_v, i| accu = yield(accu, to_a[i + 1]) unless to_a[i + 1].nil? } if args.empty?
      my_each_with_index { |_v, i| accu = yield(accu, to_a[i]) } unless args.empty?
    end
    accu
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

# rubocop: enable Metrics/ModuleLength
# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end
