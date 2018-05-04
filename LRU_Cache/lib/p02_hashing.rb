class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    each_with_index.reduce(0) do |acc, (el, i)|
      acc ^ el.hash + i.hash
    end
  end
end

class String
  def hash
    self.chars.map(&:ord).hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    self.to_a.sort.hash
  end
end
