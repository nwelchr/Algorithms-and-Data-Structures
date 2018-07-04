require_relative 'p05_hash_map'

def can_string_be_palindrome?(string) 
  hash = HashMap.new

  string.chars.each do |ch|
    hash[ch] ? hash[ch] += 1 : hash[ch] = 1
  end

  if string.length.even?
    max_odds = 0
  else
    max_odds = 1
  end

  odd_count = 0
  hash.each do |key, val|
    odd_count += 1 if val % 2 == 1

    return false if odd_count > max_odds
  end

  odd_count <= 1
end
