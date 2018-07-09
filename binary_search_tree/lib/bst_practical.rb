require "bst_node.rb"

def kth_largest(node, k)
    kth_node = { count: 0, correct_node: nil }
    reverse_inorder(node, kth_node, k)[:correct_node]
end


def reverse_inorder(node, kth_node, k)
    if node && kth_node[:count] < k
        kth_node = reverse_inorder(node.right, kth_node, k)
        if kth_node[:count] < k
            kth_node[:count] += 1
            kth_node[:correct_node] = node
        end

        if kth_node[:count] < k
            kth_node = reverse_inorder(node.left, kth_node, k)
        end
    end

    kth_node
end