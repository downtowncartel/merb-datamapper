isbns =  %w[0874176298 1556616007 0600304345 0099582309 1590599152 0395193982 
            0312062893 1858482674 0954161769 0413750108 0413732908 1880741482
            0413741605 0413760103 0413750000 8171671942 1882770285 0425157296]

Book.fix {{
  :isbn         => isbns.pick,
  :created_at   => (1..100).pick.days.ago,
  :short_title  => (short = /[:sentence:]{3,5}/.gen[0...50]),
  :long_title   => /#{short} (\w+){1,3}/.gen,
  :author       => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}",
  :publisher    => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}",
  :notes        => /[:paragraph:]?/.gen,
  :owner => User.pick
}}

User.fixture {{
  :username => username = /\w+/.gen.downcase,
  :identity => "http://#{username}.example.com",
  :email    => "#{username}@example.com",
  :name     => "#{/\w+/.gen.capitalize} #{/\w+/.gen.capitalize}"
}}