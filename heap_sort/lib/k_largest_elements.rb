require_relative 'heap'

def k_largest_elements(array, k)
    # array.heap_sort!.drop(array.length - k)
    heap = BinaryMinHeap.new
    # push && heapify up until you hit k
    k.times do
        heap.push(array.pop)
    end
    # then push, heapify up, pop, heapify down until the end (always maintains 4 elements)
    until array.empty?
        heap.push(array.pop)
        heap.extract
    end
    heap.store
end