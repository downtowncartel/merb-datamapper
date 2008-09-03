class Application < Merb::Controller
  def _call_action(action)
    repository(:default) { catch(:halt) { super(action) }}
  end
end