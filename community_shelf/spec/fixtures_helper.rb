def completed_reservation(attrs = {})
  lambda do
    attrs[:user] = User.pick

    begin
      attrs[:book] = Book.pick

      start = (11..100).pick
      start_date, end_date = start.days.ago, (1..start).pick.days.ago
    end until (attrs[:book].available?(start_date, end_date))

    {:created_at => start_date.to_datetime, :due_at => (start_date + 10.days).to_datetime, :returned_at  => end_date}.merge(attrs)
  end
end

def overdue_reservation(attrs = {})
  lambda do
    attrs[:returned_at] = nil
    attrs[:user] = User.pick
    
    begin
      attrs[:book] = Book.pick

      start_date, end_date = (11..100).pick.days.ago, 0.days.ago
    end until (attrs[:book].available?(start_date, end_date))

    {:created_at => start_date.to_datetime, :due_at => (start_date + 10.days).to_datetime}.merge(attrs)
  end
end

def checked_out_reservation(attrs = {})
  lambda do
    attrs[:returned_at] = nil
    attrs[:user] = User.pick
    
    begin
      attrs[:book] = Book.pick

      start_date, end_date = (1...10).pick.days.ago, 0.days.ago
    end until (attrs[:book].available?(start_date, end_date))

    {:created_at => start_date.to_datetime, :due_at => (start_date + 10.days).to_datetime}.merge(attrs)
  end
end