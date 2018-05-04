class MaxIntSet
  def initialize(max)
    @max = max
    @store = Array.new(max, false)
  end

  def insert(num)
    validate!(num)
    @store[num] = true unless include?(num)
  end

  def remove(num)
    validate!(num)
    @store[num] = false unless !include?(num)
  end

  def include?(num)
    @store[num] == true
  end

  private

  def is_valid?(num)
    num.between?(0, @max)
  end

  def validate!(num)
    raise "Out of bounds" unless is_valid?(num)
  end
end


class IntSet
  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
  end

  def insert(num)
    return false if include?(num)
    self[num] << num
    num
  end

  def remove(num)
    self[num].delete(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end
end

class ResizingIntSet
  attr_reader :count

  def initialize(num_buckets = 20)
    @store = Array.new(num_buckets) { Array.new }
    @count = 0
    @num_buckets = num_buckets
  end

  def insert(num)
    return false if include?(num)
    resize! if @count == num_buckets
    self[num] << num
    @count += 1
    num
  end

  def remove(num)
    @count -= 1 if self[num].delete(num)
  end

  def include?(num)
    self[num].include?(num)
  end

  private

  def [](num)
    @store[num % num_buckets]
  end

  def num_buckets
    @store.length
  end

  def resize!
    old_store = @store
    @store = Array.new(num_buckets * 2) { Array.new }
    @count = 0

    old_store.flatten.each { |num| insert(num) }
  end
end
