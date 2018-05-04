class Node
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end

  def remove
    self.prev.next = self.next if self.prev
    self.next.prev = self.prev if self.next
    self.next = nil
    self.prev = nil
  end
end

class LinkedList

  include Enumerable 
  
  def initialize
    @head = Node.new
    @tail = Node.new
    @head.next = @tail
    @tail.prev = @head
  end

  def [](i)
    self.each_with_index { |node, j| return node if i == j }
    nil
  end

  def first
    self.empty? ? nil : @head.next
  end

  def last
    self.empty? ? nil : @tail.prev
  end

  def empty?
    @head.next == @tail
  end

  def get(key)
    self.each do |node|
      return node.val if node.key == key
    end
    nil
  end

  def include?(key)
    self.any? { |node| key == node.key }
  end

  def append(key, val)
    new_node = Node.new(key, val)
    @tail.prev.next = new_node
    new_node.prev = @tail.prev
    new_node.next = @tail
    @tail.prev = new_node

    new_node
  end

  def update(key, val)
    self.each do |node|
      node.val = val if node.key == key
    end
    nil
  end

  def remove(key)
    self.each do |node|
      if node.key == key
        node.remove
        return node.val
      end
    end
    nil
  end

  def each(&prc)
    current_node = @head.next
    until current_node == @tail
      prc.call(current_node)
      current_node = current_node.next
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  # def to_s
  #   inject([]) { |acc, node| acc << "[#{node.key}, #{node.val}]" }.join(", ")
  # end
end
