namespace :dm do
  namespace :db do
    desc "populate the database with some randomly generated fixtures"
    task :populate => :automigrate do
      require 'dm-sweatshop'
      require Merb.root / :spec / :fixtures

      10.times { User.gen }
      50.times { Book.gen }
    end
  end
end