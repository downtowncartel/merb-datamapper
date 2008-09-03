namespace :dm do
  namespace :db do
    desc "populate the database with some randomly generated fixtures"
    task :populate => :automigrate do
      require 'dm-sweatshop'
      require Merb.root / :spec / :fixtures

      10.times  { User.gen }
      500.times { Book.gen }
      50.times  { Reservation.gen(:overdue) }
      50.times  { Reservation.gen(:checked_out) }
      500.times { Reservation.gen(:completed) }
    end
  end
end