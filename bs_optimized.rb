def bs(arr, target)
  bs_helper(arr, 0, arr.length - 1, target)
end

def bs_helper(arr, l, r, x)
  return nil if r < l
  mid = l + (r - l) / 2
  # found target
  if arr[mid] == x
    return mid
  # target smaller than midpoint of subsection of arr
  # pare down array to be l until midpoint - 1
  elsif arr[mid] > x
    return bs_helper(arr, l, mid - 1, x)
  # target larger than midpoint of subsection of arr
  # pare down array to be midpoint + 1 until r
  else
    return bs_helper(arr, mid + 1, r, x)
  end
end

input = [0, 3, 4, 5, 9, 10, 15, 20, 35, 42, 48, 52, 58, 62]

puts bs(input, 20)