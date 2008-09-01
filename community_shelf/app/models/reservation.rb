class Reservation
  include DataMapper::Resource

  property :id,           Serial
  property :created_at,   DateTime,   :nullable => false
  property :due_at,       DateTime,   :nullable => false
  property :returned_at,  DateTime
  property :book_id,      Integer
  property :user_id,      Integer


  belongs_to :user
  belongs_to :book


  validates_present :user, :book
end
