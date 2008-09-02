class User
  include DataMapper::Resource
 
  property :id,               Serial
  property :identity,         URI,      :length => 200, :nullable => false
  property :username,         String,   :length => 50,  :nullable => false
  property :name,             String,   :name => 100,   :nullable => false
  property :email,            String,   :length => 200, :nullable => false


  has n, :books
  has n, :reservations


  validates_is_unique :identity, :username, :email
  validates_format    :email, :as => :email_address
end