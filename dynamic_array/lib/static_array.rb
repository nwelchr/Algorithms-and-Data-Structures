# This class just dumbs down a regular Array to be statically sized.
class StaticArray
  def initialize(length)
    # we use a dynamic array as our store but it functions like a static array
    self.store = Array.new(length, nil)
  end

  # O(1)
  def [](index)
    store[index]
  end

  # O(1)
  def []=(index, value)
    store[index] = value
  end

  protected
  attr_accessor :store
end
