require "byebug"

class BSTNode
  attr_reader :value
  attr_accessor :left, :right, :parent

  def initialize(value)
    @value = value
  end

  def insert(node, value)
    if value <= @value
      if @left.nil?
        @left = node
        @left.parent = self
      else
        @left.insert(node, value)
      end

    elsif value > @value
      if @right.nil?
        @right = node
        @right.parent = self
      else
        @right.insert(node, value)
      end
    end
  end

  def find(value)
    if value == @value
      self
    elsif value <= @value
      if @left.nil?
        nil
      else
        @left.find(value)
      end
    elsif value > @value
      if @right.nil?
        nil
      else
        @right.find(value)
      end
    end
  end

  def remove(value)
    
    node = find(value)

    # no children, delete the parent's child (itself)
    if node.left.nil? && node.right.nil?
      if node.parent.left == node
        node.parent.left = nil
      elsif node.parent.right == node
        node.parent.right = nil
      end

    # two children: find max from left side of tree 
    # and promote max into removed position
    elsif node.left && node.right
      promoted = node.left.max
      promoted.remove(promoted.value)

      if node.parent.left == node
        node.parent.left = promoted
      else
        node.parent.right = promoted
      end
      promoted.parent = node.parent
    

    # one child 
    elsif node.left
      if node.parent.left == node
        # reset child of left parent node to left child of removed node
        node.parent.left = node.left
      else
        # reset child of right parent node to left child of removed node
        node.parent.right = node.left
      end
      # reset parent of left node to parent of removed node
      node.left.parent = node.parent

    elsif node.right
      if node.parent.left == node
        node.parent.left = node.right
      else
        node.parent.right = node.right
      end
      node.right.parent = node.parent
    end

  end

  # probably should move this functionality to bst file but everything else is here!
  def max
    # if the node is the rightmost element (largest), return self
    if @right.nil?
      self
    # otherwise, keep traversing to the right
    else
      @right.max
    end
  end

  def depth
    return 0 if @left.nil? && @right.nil?
    children = []
    children << @left.depth if @left
    children << @right.depth if @right
    children.max + 1 # max of all the counts so far + 1 to account for the root node
  end

  def is_balanced?
    left_depth = @left ? @left.depth : 0
    right_depth = @right ? @right.depth : 0
    return false if !((left_depth - right_depth).abs <= 1)

    left_is_balanced = @left ? @left.is_balanced? : true
    right_is_balanced = @right ? @right.is_balanced? : true

    left_is_balanced && right_is_balanced
  end

  def in_order_traversal
    # if there's a left, keep going, otherwise, return empty array
    left = @left ? @left.in_order_traversal : []
    # if there's a left, keep going, otherwise, return empty array
    right = @right ? @right.in_order_traversal : []
    # put them all together
    left + [@value] + right
  end

  def pre_order_traversal
    # if there's a left, keep going, otherwise, return empty array
    left = @left ? @left.in_order_traversal : []
    # if there's a left, keep going, otherwise, return empty array
    right = @right ? @right.in_order_traversal : []
    # put them all together
    [@value] + left + right
  end

  def post_order_traversal
    # if there's a left, keep going, otherwise, return empty array
    left = @left ? @left.in_order_traversal : []
    # if there's a left, keep going, otherwise, return empty array
    right = @right ? @right.in_order_traversal : []
    # put them all together
    left + right + [@value]
  end
    
end
