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
    return array if length <= 1

    # returns place to split length and sorts array 
    # because you pass in the array by reference 
    pivot_idx = QuickSort.partition(array, start, length, &prc)
    
    # left_length is place to split minus start
    left_length = pivot_idx - start
    # right_length is just everything else, but since pivot is in right spot keep that
    right_length = length - (left_length + 1)
    sort2!(array, start, left_length, &prc) 
    sort2!(array, pivot_idx + 1, right_length, &prc)

    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    # # choose random pivot, shuffle that position with the start position
    # pivot_idx = start + rand(length)
    # pivot = array[pivot_idx]
    # array[start], array[pivot_idx] = array[pivot_idx], array[start]

    pivot_idx = start
    pivot = array[start]

    # only focus on the values of your part of the array
    ((start + 1)..(start + length - 1)).each do |idx|
      if prc.call(pivot, array[idx]) > 0
        array[pivot_idx + 1], array[idx] = array[idx], array[pivot_idx + 1]
        pivot_idx += 1
      end
    end

    array[start], array[pivot_idx] = array[pivot_idx], array[start]

    pivot_idx
  end
end