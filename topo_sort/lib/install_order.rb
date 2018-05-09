# Given an Array of tuples, where tuple[0] represents a package id,
# and tuple[1] represents its dependency, determine the order in which
# the packages should be installed. Only packages that have dependencies
# will be listed, but all packages from 1..max_id exist.

# N.B. this is how `npm` works.

# Import any files you need to

require_relative 'topological_sort'
require_relative 'graph'

def install_order(arr)
    # vertices = (1..arr.flatten.max).to_a.map { |val| Vertex.new(val) } # slower

    max = arr[0][0]
    arr.each { |tuple| max = tuple.max > max ? tuple.max : max }

    vertices = (1..max).to_a.map { |val| Vertex.new(val) }

    arr.each do |tuple|
        from_idx = vertices.index { |v| v.value == tuple[1] }
        to_idx = vertices.index { |v| v.value == tuple[0] }
        from, to = vertices[from_idx], vertices[to_idx]
        Edge.new(from, to)
    end

    sorted = topological_sort(vertices).map

    sorted.map { |v| v.value }
end

def install_order2(arr)
    vertices = {}
    arr.each do |tuple|
        to = tuple[0]
        from = tuple[1]

        vertices[to] = Vertex.new(to) unless vertices[to]
        vertices[from] = Vertex.new(from) unless vertices[from] && !from # accounts for nil
        Edge.new(vertices[from], vertices[to]) if from
    end

    topological_sort(vertices.values).map { |v| v.value }
end

arr = [["mocha", "browserify"], ["bower", "browserify"], ["underscore", "cheerio"],
       ["mocha", "underscore"], ["mocha", "bower"], ["passport", "mocha"],
       ["hapi", "browserify"], ["browserify", nil], ["cheerio", nil]]

arr2 = [["mocha", "browserify"], ["bower", "browserify"], ["underscore", "cheerio"],
["mocha", "underscore"], ["mocha", "bower"], ["passport", "mocha"],
["hapi", "browserify"]]

p install_order2(arr)
p install_order2(arr2)

def alien_sort(dict)

    vertices = {}

    (0...dict.length - 1).each do |i|
        word1 = dict[i]
        word2 = dict[i + 1]

        counter = 0
        while true
            letter1 = word1[counter]
            letter2 = word2[counter]
            break if !letter1 || !letter2
            vertices[letter1] = Vertex.new(letter1) unless vertices[letter1]
            vertices[letter2] = Vertex.new(letter2) unless vertices[letter2]
            if letter1 != letter2
                Edge.new(vertices[letter1], vertices[letter2])
                break
            end
            counter += 1
        end
    end

    topological_sort(vertices.values).map { |v| v.value }
end

input_dict = ["baa", "abcd", "abca", "cab", "cad"]
other_input_dict = ["caa", "aaa", "aab"]
p alien_sort(input_dict)