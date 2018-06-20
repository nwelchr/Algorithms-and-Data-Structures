# For simplicity, consider the data in the range 0 to 9. 
# Input data: 1, 4, 1, 2, 7, 5, 2
#   1) Take a count array to store the count of each unique object.
#   Index:     0  1  2  3  4  5  6  7  8  9
#   Count:     0  2  2  0   1  1  0  1  0  0

#   2) Modify the count array such that each element at each index 
#   stores the sum of previous counts. 
#   Index:     0  1  2  3  4  5  6  7  8  9
#   Count:     0  2  4  4  5  6  6  7  7  7

# The modified count array indicates the position of each object in 
# the output sequence.
 
#   3) Output each object from the input sequence followed by 
#   decreasing its count by 1.
#   Process the input data: 1, 4, 1, 2, 7, 5, 2. Position of 1 is 2.
#   Put data 1 at index 2 in output. Decrease count by 1 to place 
#   next data 1 at an index 1 smaller than this index.

def counting_sort(input)
  # Step 1
  count = Array.new(10) { 0 }
  input.each do |el|
    count[el] += 1
  end

  # Step 2
  count.each_index do |i|
    next if i == 0
    count[i] += count[i-1]
  end

  # Step 3
  output = []
  input.each do |el|
    count[el] -= 1
    output[count[el]] = el
  end
  output
end

input_arr = [5, 2, 3, 4, 3, 1, 9, 0, 3, 7, 8]
counting_sort(input_arr)
# expect(counting_sort(input_arr)).to_equal([0, 1, 2, 3, 3, 3, 4, 5, 7, 8, 9])