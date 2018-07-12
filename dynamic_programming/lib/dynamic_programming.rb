require 'byebug'

class DynamicProgramming

  def initialize
    @blair_cache = { 1 => 1, 2 => 2 }
    @frog_cache = { 
      1 => [[1]], 
      2 => [[1, 1], [2]], 
      3 => [[1, 1, 1], [1, 2], [2, 1], [3]]
     }
    @super_frog_cache = {
      1 => [[1]], 
      2 => [[1, 1], [2]], 
      3 => [[1, 1, 1], [1, 2], [2, 1], [3]]
    }
    @maze_cache_2 = []

    @maze_cache = {}
  end

  def blair_nums(n)
    build_blairs(n)
    @blair_cache[n]
  end

  def build_blairs(n)
    return @blair_cache[n] if @blair_cache[n]
    next_blair = build_blairs(n-1) + build_blairs(n-2) + 2*(n-1) - 1
    @blair_cache[n] = next_blair
    return next_blair
  end

  def frog_hops_bottom_up(n)
    # local_cache = frog_cache_builder(n)
    # local_cache[n]
    frog_cache_builder(n)[n] # no need to waste the memory
  end

  def frog_cache_builder(n)
    frog_hops = { 
      1 => [[1]], 
      2 => [[1, 1], [2]], 
      3 => [[1, 1, 1], [1, 2], [2, 1], [3]]
     }

    return frog_hops if n <= 3

    (4..n).each do |n|
      frog_hops_1 = frog_hops[n-1].map { |arr| arr + [1] }
      frog_hops_2 = frog_hops[n-2].map { |arr| arr + [2] }
      frog_hops_3 = frog_hops[n-3].map { |arr| arr + [3] }
      frog_hops[n] = frog_hops_1 + frog_hops_2 + frog_hops_3
    end
    
    frog_hops
  end

  def frog_hops_top_down(n)
    frog_hops_top_down_helper(n)
  end

  def frog_hops_top_down_helper(n)
    return @frog_cache[n] if @frog_cache[n]
    frog_hops_1 = frog_hops_top_down_helper(n-1).map { |arr| arr + [1] }
    frog_hops_2 = frog_hops_top_down_helper(n-2).map { |arr| arr + [2] }
    frog_hops_3 = frog_hops_top_down_helper(n-3).map { |arr| arr + [3] }
    @frog_cache[n] = frog_hops_1 + frog_hops_2 + frog_hops_3
    @frog_cache[n]
  end

  def super_frog_hops(n, k)
    return [[1]*n] if k == 1
    return @super_frog_cache[n] if @super_frog_cache[n]
    frog_hops = []
    k = n if k > n
    n.downto(2).each do |i|
      frog_hops += super_frog_hops(i - 1, k).map { |arr| [n - i + 1] + arr }
    end
    @super_frog_cache[n] = frog_hops
    @super_frog_cache[n]
  end

  def knapsack(weights, values, capacity)
    return 0 if capacity <= 0 || weights.empty?

    solution_table = knapsack_table(weights, values, capacity)

    solution_table[capacity][-1]
  end

  # Helper method for bottom-up implementation
  def knapsack_table(weights, values, capacity)
    solution_table = []

    # Build solutions for knapsacks of increasing capacity
    (0..capacity).each do |i|
      solution_table[i] = []

      # Go through the weights by index
      (0...weights.length).each do |j|
        if i == 0
          # if capacity is 0, 0 is the only value that can be placed into the slot
          solution_table[i][j] = 0
        elsif j == 0
          # for the first item in our list, we can check for capacity
          # if weight is less than capacity, put 0, else put value
          solution_table[i][j] = weights[0] > i ? 0 : values.first
        else
          # first option: entry considering previous item at this capacity
          option1 = solution_table[i][j - 1]
          
          # second option: assuming enough capacity, the maximized value of the smaller bag
          # this is where we go up and left
          option2 = i < weights[j] ? 0 : solution_table[i - weights[j]][j - 1] + values[j]

          # choose the max of these options
          optimum = [option1, option2].max
          solution_table[i][j] = optimum
        end
      end
    end

    return solution_table
  end

  # def maze_solver2(maze, start_pos, end_pos)
  #   @maze_cache << start_pos unless @maze_cache.last == start_pos

  #   return end_pos if start_pos == end_pos
  #   row, col = start_pos

  #   if [" " ,"F"].include?(maze[row][col + 1])
  #     maze[row][col + 1] = "V"
  #     maze_solver(maze,[row,col + 1], end_pos)

  #   elsif [" " ,"F"].include?(maze[row + 1][col])
  #     maze[row + 1][col] = "V"
  #     maze_solver(maze, [row + 1,col], end_pos)

  #   elsif [" " ,"F"].include?(maze[row][col-1]) && (col - 1 > 0)
  #     maze[row][col-1] = "V"
  #     maze_solver(maze, [row,col-1], end_pos)

  #   elsif [" " ,"F"].include?(maze[row - 1][col]) && (col - 1 > 0)
  #     maze[row - 1][col] = "V"
  #     maze_solver(maze, [row - 1,col], end_pos)

  #   else
  #     @maze_cache.pop
  #     maze_solver(maze, @maze_cache.last, end_pos)
  #   end

  #   @maze_cache
  # end
  

  def maze_solver(maze, start_pos, end_pos)
    @maze_cache[start_pos] = nil
    queue = [start_pos]

    until queue.empty?
      current_pos = queue.pop
      break if current_pos == end_pos

      

      get_moves(maze, current_pos).each do |move|
        @maze_cache[move] = current_pos
        queue << move
      end

    end
    
    
    @maze_cache.include?(end_pos) ? path_from_cache(end_pos) : nil
  end

  def get_moves(maze, pos)
    x, y = pos
    moves = []
    directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]

    directions.each do |new_x, new_y| # decompose the direction into the two parts

      next_pos = [x + new_x, y + new_y]

      if is_valid_pos?(maze, next_pos)
        moves << next_pos unless @maze_cache.include?(next_pos)
      end

    end

    

    moves
  end

  def is_valid_pos?(maze, pos)
    x, y = pos
    x >= 0 && y >= 0 && x < maze.length && y < maze.first.length && maze[x][y] != "X"
  end

  def path_from_cache(end_pos)
    
    path = []
    current = end_pos

    while current
      path.unshift(current)
      current = @maze_cache[current]
    end

    

    path
  end

end
