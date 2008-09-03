module XAuth::SessionMixin
  ##
  # @return [TrueClass, FalseClass]
  # 
  def authenticated?
    !user.nil?
  end

  ##
  # returns the active user for this session, or nil if there's no user claiming this session
  # @returns [User, NilClass]
  def user
    @user ||= self[:user_id].blank? ? nil : User.get(self[:user_id])
  end

  ## 
  # allows for manually setting the user
  # @returns [User, NilClass]
  def user=(user)
    case user
    when User
      self[:user_id] = user.id
      @user = user
    else
      abandon!
    end
    @user
  end

  ##
  # retrieve the claimed identity and verify the claim
  # 
  # Uses the strategies setup on Authentication executed in the context of the controller to see if it can find
  # a user object
  # @return [User, NilClass] the verified user, or nil if verification failed
  # @see User::encrypt
  # 
  def authenticate!(controller)
    XAuth.authenticate!(controller, self)
  end

  ##
  # abandon the session, log out the user, and empty everything out
  # 
  def abandon!
    XAuth.abandon!(controller, self)
  end
end