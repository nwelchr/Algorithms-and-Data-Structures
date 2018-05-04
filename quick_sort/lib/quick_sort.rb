require "byebug"

class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    return array if array.length < 1
    pivot = array.first
    left = array.select{ |val| val < pivot }
    right = array.select{ |val| val >= pivot }
    return sort1(left) + [pivot] + sort1(right)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    return array if length < 2

    # returns place to split length and sorts array 
    # because you pass in the array by reference 
    pivot_idx = partition(array, start, length, &prc)
    
    # left_length is place to split minus start
    left_length = pivot_idx - start
    # right_length is just everything else, but since pivot is in right spot keep that
    right_length = length - left_length - 1
    return sort2!(array, start, left_length, &prc) 
    return sort2!(array, pivot_idx + 1, right_length, &prc)

    p array, 'final array'

    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    p array
    # choose random pivot, shuffle that position with the start position
    pivot_idx = start + rand(length)
    pivot = array[pivot_idx]
    array[start], array[pivot_idx] = array[pivot_idx], array[start]

    pivot_idx = start

    p array

    # only focus on the values of your part of the array
    ((start + 1)...(start + length)).each do |idx|
      curr_val = array[idx]
      p pivot 
      p curr_val
      if prc.call(pivot, curr_val) > 0
        array[pivot_idx], array[idx] = array[idx], array[pivot_idx]
        pivot_idx += 1
      end
      p array
    end

    pivot_idx
  end
end