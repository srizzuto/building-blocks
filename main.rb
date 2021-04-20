module Enumerable
    def my_each
        for i in 0..size-1
          yield(at(i)) 
        end
    end

    def my_each_with_index
        for i in 0..size-1
            yield(i,at(i))
        end
    end

    def my_select
        selected = []
        for i in 0..size-1
            selected.push(yield(at(i))) 
        end
        puts selected
        selected
    end

    def my_all?
        if block_given?
            for i in 0..size-1
                unless yield(at(i)) then return false end
            end
          else
            for i in 0..size-1
                unless at(i) then return false end
            end
          end
        
        true
    end
end
[1,2,3].my_each { |element|  p element }
[1,2,3].my_each_with_index { |index,element|  p "#{element} at #{index}" }
[1,2,3].my_select{|element| unless element == 3 then  element 
end}
puts [nil,2,3].my_all?