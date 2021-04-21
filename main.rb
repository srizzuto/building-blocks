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
    i = 0
    while i < size
      yield(i, at(i))
      i += 1
    end
  end

  def my_select
    selected = []
    i = 0
    while i < size
      selected.push(yield(at(i)))
      i += 1
    end
    selected
  end

  def my_all?
    if block_given?
      i = 0
      while i < size
        unless yield(at(i)) then return false end
        i += 1
      end
    else
      i = 0
      while i < size
        unless at(i) then return false end
        i += 1
      end
    end
    true
  end

  def my_any?
    unless empty?
      if block_given?
        i = 0
        while i < size
          if yield(at(i)) then return true end
          i += 1
        end
      else
        i = 0
        while i < size
          if at(i) then return true end
          i += 1
        end
      end
    end
    false
  end

  def my_none?
    unless empty?
      if block_given?
        i = 0
        while i < size
          if yield(at(i)) then return false end
          i += 1
        end
      else
        i = 0
        while i < size
          if at(i) then return false end
          i += 1
        end
      end
    end
    true
  end

  def my_count(args = nil)
    counter = 0
    if block_given?
      i = 0
      while i < size
        if yield(at(i)) then counter += 1 end
        i += 1
      end
      return counter
    elsif !args.nil?
      i = 0
      while i < size
        if at(i) == args then counter += 1 end
        i += 1
      end
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
    if block_given?
      map_array = []
      i = 0
      while i < size
        map_array.push(yield(at(i)))
        i += 1
      end
      return map_array
    elsif args != nil
      my_proc = args
      map_array = []
      i = 0
      while i < size
        map_array.push(my_proc.call(at(i)))
        i += 1
      end
      return map_array
    end
    self
  end
end

def multiply_els(array)
  array.my_inject { |multi, n| multi * n }
end

puts multiply_els([1, 2, 4, 4])
