class Sessions < Application

  def new
    redirect url(:dash) if session.authenticate!(self)
  end

  def create
    session.authenticate!(self)

    redirect url(:dash)
  end

  def destroy
    session.clear

    redirect url(:dash)
  end
end