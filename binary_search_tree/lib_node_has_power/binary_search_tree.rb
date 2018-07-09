require "byebug"

# There are many ways to implement these methods, feel free to add arguments 
# to methods as you see fit, or to create helper methods.

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    new_node = BSTNode.new(value)
    @root.nil? ? @root = new_node : @root.insert(new_node, value)  
  end

  def find(value, tree_node = @root)
    @root.nil? ? nil : tree_node.find(value)
  end

  def delete(value)
    if @root.nil? # if the tree is empty
      nil
    elsif @root.left.nil? && @root.right.nil? # if the root node is the only node
      @root = nil
    else
      @root.remove(value)
    end
  end

  # helper method for #delete:
  def maximum(tree_node = @root)
    tree_node.nil? ? nil : tree_node.max
  end

  def depth(tree_node = @root)
    return 0 if @root.left.nil? && @root.right.nil?
    @root.depth
  end 

  def is_balanced?(tree_node = @root)
    return true if tree_node.nil?
    tree_node.is_balanced?
  end

  def in_order_traversal(tree_node = @root, arr = [])
    tree_node.in_order_traversal
  end

  private
  # optional helper methods go here:

end
