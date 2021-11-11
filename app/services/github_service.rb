class GithubService

  def contributors
    users = Hash.new
    body = get_url("/repos/yosoynatebrown/little-esty-shop/contributors?page=2?access_token=fff")
    
  end

  def usernames
    get_url("/repos/yosoynatebrown/little-esty-shop/contributors?page=2?access_token=fff")
  end

  def commits
    get_url("/repos/yosoynatebrown/little-esty-shop/contributors?page=2?access_token=fff")
  end

  def merged_pr_count
    get_url("/search/issues?q=repo:yosoynatebrown/little-esty-shop%20type:pr%20is:merged")[:total_count]
  end

  def repo_name
    get_url("/repos/yosoynatebrown/little-esty-shop")[:name]
  end

  def get_url(url)
    response = Faraday.get("https://api.github.com#{url}")
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end
