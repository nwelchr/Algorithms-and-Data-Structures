# GET /account/:instagram_id
# {
#   instagram_id: string,
#   username: string,
#   biography: string,
#   follower_count: string
# }

# GET /account/:instagram_id/followers?cursor=:optional_cursor
# {
#   data: [
#     instagram_id,
#     instagram_id,
#     ...
#   ],
#   next_page_cursor: nil
# }

# Create InstagramAccount object class template
class InstagramAccount()
  def initialize(instagram_id, username, biography, follower_count, followers)
    self.instagram_id = instagram_id
    self.username = username
    self.biography = biography
    self.follower_count = follower_count
    self.followers = followers
  end
end

require 'net/http'

# Define main class
class InstagramCrawler()
  # creates a getter method to access accounts
  attr_reader :popular_accounts

  def initialize(seed_instagram_id)
    # i.e. the list we will end up wanting of users with over 5000 followers
    @popular_accounts = []
    # hash of already visited accounts in order to facilitate DFS of graph
    @visited_accounts = {}
    @seed_instagram_id = seed_instagram_id
  end

  def crawl_instagram_accounts
    bfs_queue = []
    # push initial seed value onto queue
    bfs_queue.push(@seed_instagram_id)
    while bfs_queue
      # shift first value off queue, make api request with value to get user object, then make into InstagramAccount object
      curr = InstagramAccount.new(get_account(bfs_queue.shift))
      # set that account as visited
      @visited_accounts[curr.instagram_id] = true
      # add to final result if they have at least 5000 followers
      @popular_accounts.push(curr) if curr.follower_count >= 5000
      # retrieve array of ids of all followers
      follower_ids = get_followers(curr.instagram_id)
      # iterate over followers
      follower_ids.each do |follower_id|
        # add to the queue if it hasn't already been visited
        bfs_queue.push(follower_id) if !@visited[follower_id]
      end
    end
    # return the accounts with at least 5000 followers
    popular_accounts
  end

  private

  # for retrieving individual user data
  def get_account(instagram_id)
    api_call(`http://api.instagram.com/account/#{instagram_id}`, nil)
  end
  
  # for retrieving the list of user ids
  def get_followers(instagram_id)
    follower_ids = []
    curr_page = {}
    # keep calling api until there is no next page. 
    # unsure as to how to incorporate the next_page_cursor into the get request itself,
    # as I do not have access to instagram's actual API.
    # Ideally it would be as easy as adding data to the get request
    # to specify 
    while true
      # make api call and pass in pagination token (next_page_cursor returned from api call) if there is curr_page, else nil
      pagination_token = curr_page.empty? ? curr_page.next_page_cursor : nil
      curr_page = api_call(`http://api.instagram.com/account/#{instagram_id}`, pagination_token)
      follower_ids.append(curr_page.data)
      # break when there is no more data to fetch
      break if curr_page.next_page_cursor.nil? 
    end
    follower_ids
  end
  
  def api_call(req_url, pagination_token)
    url = URI.parse(`http://api.instagram.com/account/#{instagram_id}`)
    req = Net::HTTP::Get.new(url.to_s)
    # if this is coming from the get_followers method, pass the pagination token to tell the database
    # how much data has already been retrieved
    req['next_page_cursor'] = pagination_token if pagination_token
    res = Net::HTTP.start(url.host, url.port) {|http| http.request(req)}
    res.body
  end
end

# Create instance of InstagramCrawler and pass in sample seed_instagram_id
problem = InstagramCrawler.new(5)
# solution will be an array of InstagramAccount objects who have at least 5000 followers
solution = problem.crawl_instagram_accounts

# Considerations:
# 1. Instagram's database would need to be strongly connected. 
#    There would need to be a path between any two vertices to ensure
#    that the entire database is being accessed from any initial ID.
# 2. The API requests are all fake, thus having test data would require
#    seeding one's own database. This implementation is fine for
#    planning purposes, but ideally there would be a graph network
#    with which to test this implementation.
# 3. This is simply a BFS of a graph, which is a sensible solution
#    given that you are given all the followers of a particular
#    user, and it is more snesible to iterate over that array of data.
# 4. I created an InstagramCrawler class in order to maintain access
#    to a few 'stores' of data that would make it easier for me to both
#    organize data as well as separate concerns. I could have also
#    implemented this in Ruby with Proc closures, which work similarly
#    to Javascript closures, and allow me to encapsulate data while
#    giving certain variables 'global' status within a slightly larger scope.