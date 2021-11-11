class ApplicationController < ActionController::Base
  helper_method :application

  def application
    @contributors = GithubService.contributors
    @merged_pr_count = GithubService.merged_pr_count
    @repo_name = GithubService.repo_name
  end

end
