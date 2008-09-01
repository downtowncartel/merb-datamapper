class Book
  include DataMapper::Resource

  property :id,               Serial
  property :isbn,             String,   :length => 13,  :nullable => false
  property :created_at,       DateTime,                 :nullable => false
  property :short_title,      String,   :length => 50
  property :long_title,       String,   :length => 200
  property :author,           String,   :length => 200
  property :publisher,        String,   :length => 200
  property :notes,            Text
  property :owner_id,         Integer


  is :permalink, :title, :length => 60


  belongs_to :owner, :class_name => "User"
  has n, :reservations


  validates_present :title, :owner


  def title
    @short_title.blank? ? @long_title : @short_title
  end
end