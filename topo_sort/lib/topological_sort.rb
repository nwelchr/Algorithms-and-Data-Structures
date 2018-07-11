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

# Kahn's
# O(|V| + |E|).
def topological_sort(vertices)
    in_edge_counts = {}
    queue = []
  
    vertices.each do |v|
      in_edge_counts[v] = v.in_edges.count
      queue << v if v.in_edges.empty?
    end
  
    sorted_vertices = []
  
    until queue.empty?
      vertex = queue.shift
      sorted_vertices << vertex
  
      vertex.out_edges.each do |e|
        to_vertex = e.to_vertex
  
        in_edge_counts[to_vertex] -= 1
        queue << to_vertex if in_edge_counts[to_vertex] == 0
      end
    end
  
    sorted_vertices
  end
  
  # Tarjans
  
  def topological_sort(vertices)
    ordering = []
    explored = Set.new
  
    vertices.each do |vertex| # O(|v|)
      dfs!(vertex, explored, ordering) unless explored.include?(vertex)
    end
  
    ordering
  end
  
  def dfs!(vertex, explored, ordering)
    explored.add(vertex)
  
    vertex.out_edges.each do |edge| # O(|e|)
      new_vertex = edge.to_vertex
      dfs!(new_vertex, explored, ordering) unless explored.include?(new_vertex) 
    end
  
    ordering.unshift(vertex)
  end
