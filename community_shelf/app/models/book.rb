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
  validates_with_method :validate_isbn


  before :valid?, :set_timestamp_properties
  after :create,  :record_activity

  def self.by_catalog(term)
    all(:slug.like => "#{term}%")
  end

  def self.added_after(start_time)
    all(:created_at.gt => start_time, :order => [:created_at.desc])
  end

  def self.added_before(end_time)
    all(:created_at.lte => end_time, :order => [:created_at.desc])
  end

  def title
    @short_title.blank? ? @long_title : @short_title
  end

  def validate_isbn
    if !self.isbn.blank? && self.isbn.size != 13
      [false, "'#{@isbn}' is in an invalid ISBN format"]
    elsif ISBN_Tools.is_valid?(@isbn)
      true
    else
      [false, "'#{@isbn}' is an invalid ISBN number"]
    end
  end

  def overdue?
    not reservations.overdue.empty?
  end

  def available?(*args)
    reservations.overlapping(*args).empty?
  end

  def record_activity
    Activity::Submission.create(:book => self, :user => self.owner)
  end
end