def peak(arr)
  peak_helper(arr, 0, arr.length - 1)
end

def peak_helper(arr, l, r)
  mid = l + (r - l) / 2
  # found target
  if ((mid == 0 || arr[mid - 1] <= arr[mid]) && (mid == arr.length - 1 || arr[mid + 1] <= arr[mid]))
    return mid
  # target smaller than midpoint of subsection of arr
  # pare down array to be l until midpoint - 1
  elsif (mid > 0 && arr[mid - 1] > arr[mid])
    return peak_helper(arr, l, mid - 1)
  # target larger than midpoint of subsection of arr
  # pare down array to be midpoint + 1 until r
  else
    return peak_helper(arr, mid + 1, r)
  end
end

input = [0, 3, 4, 5, 3, 10, 15, 20, 35, 42, 48, 52, 58, 62]

puts peak(input)