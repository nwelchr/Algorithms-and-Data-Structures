require "bst_node.rb"

def kth_largest(tree_node, k)
    arr = tree_node.in_order_traversal
    tree_node.find(arr[arr.length - k])
end


## wooot
def reverse_inorder(tree_node, kth_node, k)
    if tree_node && kth_node[:count] < kth_largest
        kth_node = reverse_inorder(tree_node.right, kth_node, k)
        if kth_node[:count] < kth_largestkth_node[:count] += 1
            kth_node[:corrent_node] = tree_node
        end

        if kth_node[:count] < kth_largest
            kth_node = reverse_inorder(tree_node.left, kth_node, k)
        end
    end

    kth_node
end