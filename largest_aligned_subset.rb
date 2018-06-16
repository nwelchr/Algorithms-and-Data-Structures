# from def solution(A, M): 
require 'byebug'

def solution(arr, target)
  # create new Hash/Dictionary with 0 as default value
  modulo_vals = Hash.new() {0}
  arr.each do |el|
    # take the modulo of each number with the target value/M
    # and increment the modulo by 1 each time
    # explanation: the difference between two numbers with
    # the same modulo with respect to a given number
    # will always be identical
    modulo_vals[el % target] += 1
  end
  modulo_vals.values.max
end

test_arr = [-3, -2, 1, 0, 8, 7, 1]
solution(test_arr, 3)