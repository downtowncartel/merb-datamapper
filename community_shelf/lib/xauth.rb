module XAuth
  class << self
    attr_accessor :strategies
  end

  self.strategies = []

  def self.setup(name, klass = nil, opts = {})
    klass, opts = nil, klass if klass.is_a? Hash
    name, klass = name.default_name, name if klass.nil?

    raise StrategyExists, "#{name} strategy already setup" if @strategies.any? {|n, k, o| n == name}

    @strategies << [name, klass, opts]
  end

  def self.authenticate!(controller, session)
    @strategies.any? do |name, klass, opts|
      klass.new(session, opts).authenticate!(controller)
    end
  end

  class NotSupportedError < Exception; end
  
  class StrategyExists < Exception; end
  
  class StrategyNotFound < Exception; end
end

# injecting Merb::DataMapperSession with authentication extensions
class Merb::BootLoader::AuthenticatedSessions < Merb::BootLoader
  after MixinSessionContainer
  
  def self.run
    # Very kludgy way to get at the sessions object in include the new stuff
    Merb.logger.info "Mixing in XAuth extensions into the session object"
    controller = Application.new(Merb::Request.new({}))
    controller.setup_session
    controller.session.class.send(:include,  XAuth::SessionMixin)    
  end
end