require_relative 'graph'
require 'byebug'

# Implementing topological sort using both Khan's and Tarian's algorithms

def topological_sort(vertices)
    sorted = []
    top = []

    ## unshift first round of vertices
    vertices.each do |vertex|
        if vertex.in_edges.empty?
            top.unshift(vertex)
        end
    end

    ## until top is empty...
    until top.empty?
        curr = top.pop
        sorted << curr
        
        edges_len = curr.out_edges.length
        edges_len.times do
            edge = curr.out_edges.shift
            if edge.to_vertex.in_edges.empty?
                top.unshift(edge)
            end
            edge.destroy!
        end

        ## shift on next round of vertices
        vertices.each do |vertex|
            if vertex.in_edges.empty?
              top.unshift(vertex) unless top.include?(vertex) || sorted.include?(vertex)
            end
        end
    end

    # if we managed to take all the nodes from the graph, return sorted
    # otherwise, there was a cycle and it's impossible to sort
    sorted.length == vertices.length ? sorted : []
end
