class XAuth::OpenIDStrategy
  attr_accessor :session, :store

  def initialize(session, opts = {})
    @session = session
    @store_type = opts[:store_type]

    @store = opts[:store]
  end

  def authenticate!(controller)
    if controller.params['openid.mode']
      response = consumer(session).complete(controller.params.only(*openid_parameters).to_mash, return_path(controller))
      if response.status.to_s == 'success'
        if user = User.first(:identity => response.identity_url)
          session.user = user
          true
        else
          session['openid.url'] = response.identity_url
          throw(:halt, controller.redirect(controller.url(:signup)))
        end
      else
        raise Unauthenticated, session.message
      end
    elsif openid_url = controller.params[:'openid.url']
      checkid_request = consumer(session).begin(openid_url) 
      throw(:halt, controller.redirect(checkid_request.redirect_url("#{controller.request.protocol}://#{controller.request.host}", controller.absolute_url(:login))))
    else
      false
    end
  end

  def consumer(session)
    @consumer ||= OpenID::Consumer.new(session, @store)
  end

  def openid_parameters
    %w[openid.claimed_id openid.ns openid.return_to openid.sig rp_nonce openid.op_endpoint openid.response_nonce openid1_claimed_id openid.identity openid.assoc_handle openid.signed openid.mode]
  end

  def return_path(controller)
    if controller.request.protocol.include?('://')
      controller.request.protocol + controller.request.host + controller.request.path
    else
      "#{controller.request.protocol}://#{controller.request.host}" + controller.request.path
    end
  end
end