require "bst_node"

# There are many ways to implement these methods, feel free to add arguments 
# to methods as you see fit, or to create helper methods.

class BinarySearchTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def insert(value)
    @root = insert_into_tree(@root, value) 
  end

  def find(value, node = @root)
    return nil if node.nil?
    return node if node.value == value

    if value < node.value
      find(value, node.left)
    elsif value > node.value
      find(value, node.right)
    end 
  end

  def delete(value)
    @root = delete_from_tree(@root, value)
  end

  # helper method for #delete:
  def maximum(node = @root)
    if node.right
      max_node = maximum(node.right)
    else
      max_node = node
    end

    max_node
  end

  def depth(node = @root)
    if node.nil?
      return -1
    else
      left_depth = depth(node.left)
      right_depth = depth(node.right)

      if left_depth > right_depth
        return left_depth + 1
      else
        return right_depth + 1
      end
    end
  end 

  def is_balanced?(node = @root)
    return true if node.nil?

    balanced = true
    left_depth = depth(node.left)
    right_depth = depth(node.right)
    balanced = false if (left_depth - right_depth).abs > 1

    if balanced && is_balanced?(node.left) && is_balanced?(node.right)
      return true
    end

    false
  end

  def in_order_traversal(node = @root, arr = [])
    if node.left
      in_order_traversal(node.left, arr)
    end

    arr.push(node.value)

    if node.right
      in_order_traversal(node.right, arr)
    end

    arr
  end

  private
  # optional helper methods go here:
  def insert_into_tree(node, value)
    return BSTNode.new(value) if node.nil?

    if value <= node.value
      node.left = insert_into_tree(node.left, value)
    elsif value > node.value
      node.right = insert_into_tree(node.right, value)
    end

    node
  end

  def delete_from_tree(node, value)
    if value == node.value
      node = remove(node)
    elsif value <= node.value
      node.left = delete_from_tree(node.left, value)
    elsif value > node.value
      node.right = delete_from_tree(node.right, value)
    end

    node
  end

  def remove(node)
    # if no children, just remove it
    if node.left.nil? && node.right.nil?
      node = nil
    elsif node.left && node.right.nil?
      node = node.left
    elsif node.left.nil? && node.right
      node = node.right
    else
      # if the node has two children, promote the max node
      # in its left subtree to replace itself
      # if that specific node that was promoted has children,
      # then promote
      node = replace_parent(node)
    end

    node
  end

  def replace_parent(node)
    replacement_node = maximum(node.left)
    if replacement_node.left
      promote_child(node.left)
    end

    # need to update children pointers of replacement node
    replacement_node.left = node.left
    replacement_node.right = node.right

    replacement_node
  end

  def promote_child(node)
    if node.right
      current_parent = node
      max_node = maximum(node.right)
    else
      return node
    end

    current_parent.right = max_node.left
  end

end
