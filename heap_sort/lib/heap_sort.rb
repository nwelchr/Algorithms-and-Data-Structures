require_relative "heap"
require "byebug"

class Array
  def heap_sort!
    1.upto(length - 1) do |i|
      BinaryMinHeap.heapify_up(self, i, i)
    end
    (length - 1).downto(1) do |i|
      self[i], self[0] = self[0], self[i]
      BinaryMinHeap.heapify_down(self, 0, i)
    end
    self.reverse!
  end
end
