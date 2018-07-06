require "byebug"

class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    return array if array.length < 1
    new_pivot = rand(array.length)
    array[0], array[pivot] = array[new_pivot], array[0]

    pivot = array.first
    left = array.select{ |val| val < pivot }
    right = array.select{ |val| val >= pivot }
    return sort1(left) + [pivot] + sort1(right)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    return array if length <= 1

    # returns place to split length and sorts array 
    # because you pass in the array by reference 
    pivot_idx = partition(array, start, length, &prc)
    
    # left_length is place to split minus start
    left_length = pivot_idx - start
    # right_length is just everythinng else, but since pivot is in right spot keep that
    right_length = length - (left_length + 1)
    sort2!(array, start, left_length, &prc) 
    sort2!(array, pivot_idx + 1, right_length, &prc)

    array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new { |a, b| a <=> b }

    # choose random pivot, shuffle that position with the start position
    # doesn't work for spec
    # pivot_idx = start + rand(length)
    # pivot = array[pivot_idx]
    # array[start], array[pivot_idx] = array[pivot_idx], array[start]

    # first way...
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

    ## OR...
    # pivot_idx, pivot = start, array[start]
    # ((start + 1)...(start + length)).each do |idx|
    #   val = array[idx]
    #   if prc.call(pivot, val) < 1
    #     # if the element is greater than or equal to the pivot, leave
    #     # where it is.
    #   else
    #     # Three-way shuffle: pivot_idx + 1 => idx, pivot_idx =>
    #     # pivot_idx + 1, idx => pivot_idx.
    #
    #     # move self[pivot_idx + 1] to idx, which keeps this bigger item
    #     # to the right of the pivot.
    #     array[idx] = array[pivot_idx + 1]
    #     # move the pivot forward one, to where the larger item used to live.
    #     array[pivot_idx + 1] = pivot
    #     # move the smaller item to one to the left of the pivot.
    #     array[pivot_idx] = val
    #
    #     pivot_idx += 1
    #   end
    # end

    pivot_idx
  end
end