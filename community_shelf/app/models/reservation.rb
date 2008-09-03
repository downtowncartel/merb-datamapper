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

  def self.checked_out
    all(:returned_at => nil)
  end

  def self.overdue
    checked_out.all(:due_at.lt => DateTime.now)
  end

  def self.by(user)
    all(Reservation.user.id => user.id)
  end

  def self.for(book)
    all(Reservation.book.id => book.id)
  end

  def self.starting_in(start_time, end_time)
    all(:created_at.gte => start_time, :created_at.lte => end_time)
  end

  def self.ending_in(start_time, end_time)
    all(:returned_at.gte => start_time, :returned_at.lte => end_time)
  end

  def self.active_in(start_time, end_time)
    starting_in(start_time, end_time) + ending_in(start_time, end_time)
  end

  def self.overlapping(start_time = DateTime.now, end_time = DateTime.now)
    active_in(start_time, end_time) + all(:returned_at => nil, :created_at.lte => start_time)
  end

  #def self.overlapping(start_time, end_time = DateTime.now)
  #  all(:conditions => ['((created_at >= ? AND created_at <= ?) OR (returned_at >= ? AND returned_at <= ?) OR (returned_at IS ? AND (created_at <= ?)))', start_time, end_time, start_time, end_time, nil, start_time])
  #end

  def checkin
    update_attributes(:returned_at => DateTime.now)
  end
end
