# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < size
      yield(at(i))
      i += 1
    end
  end

  def my_each_with_index
    for i in 0..size - 1
      yield(i, at(i))
    end
  end

  def my_select
    selected = []
    for i in 0..size - 1
      selected.push(yield(at(i)))
    end
    selected
  end

  def my_all?
    if block_given?
      for i in 0..size - 1
        unless yield(at(i)) then return false end
      end
    else
      for i in 0..size - 1
        unless at(i) then return false end
      end
    end
    true
  end

  def my_any?
    unless empty?
      if block_given?
        for i in 0..size - 1
          if yield(at(i)) then return true end
        end
      else
        for i in 0..size - 1
          if at(i) then return true end
        end
      end
    end
    false
  end

  def my_none?
    unless empty?
      if block_given?
        for i in 0..size - 1
          if yield(at(i)) then return false end
        end
      else
        for i in 0..size - 1
          if at(i) then return false end
        end
      end
    end
    true
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      for i in 0..size - 1
        if yield(at(i)) then counter += 1 end
      end
      return counter
    elsif !args.nil?
      for i in 0..size - 1
        if at(i) == args then counter += 1 end
      end
      return counter
    end
    size
  end

  def my_inject(args = 0)
    result = at(args)
    for i in args + 1..size - 1
      result = yield(result, at(i))
    end
    result
  end

  def my_map(args = nil)
    if block_given?
      map_array = []
      for i in 0..size - 1
        map_array.push(yield(at(i)))
      end
      return map_array
    elsif args != nil
      my_proc = args
      map_array = []
      for i in 0..size - 1
        map_array.push(my_proc.call(at(i)))
      end
      return map_array
    end
    self
  end
end

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end

[1, 2, 3].my_each { |element| p element }
[1, 2, 3].my_each_with_index { |index, element| p "#{element} at #{index}" }
[1, 2, 3].my_select { |element| unless element == 3 then element end }
puts [nil, 2, 3].my_all?
puts [1, 2, 3].my_any? { |element| element == 3 }
puts [1, 2, 3].my_none? { |element| element == 0 }
puts [1, 2, 4, 4].my_count { |element| element.even? }
puts [1, 2, 4, 4].my_map(proc { |element| element * 3 })
puts [1, 2, 4, 4].my_inject { |sum, n| sum + n }
puts multiply_els([1, 2, 4, 4])
