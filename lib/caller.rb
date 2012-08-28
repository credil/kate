require 'net/http'
require 'net/https'
require 'uri'
require 'profile'
require 'utils'
require 'logger'

# The module has a class and a wrapper method wrapping NET:HTTP methods to simplify calling PayPal APIs.

module PayPalSDKCallers
  class Caller
    include PayPalSDKProfiles
    include PayPalSDKUtils
    attr_reader :ssl_strict

    # CTOR
    def initialize(ssl_verify_mode=false)
      @ssl_strict = ssl_verify_mode
      @@profile   ||= PayPalSDKProfiles::Profile.new
    end

    # This method uses HTTP::Net library to talk to PayPal
    # WebServices. This is the method what merchants should mostly care
    # about.
    # It expects an hash arugment which has the method name and
    # paramater values of a particular PayPal API.
    # It assumes and uses the credentials of the merchant which is the
    # attribute value of credentials of profile class in
    # PayPalSDKProfiles module.
    # It assumes and uses the client information which is the
    # attribute value of client_info of profile class of
    # PayPalSDKProfiles module.
    # It will also work behind a proxy server. If the calls need be to
    # made via a proxy sever, set USE_PROXY flag to true and specify
    # proxy server and port information in the profile class.

    def credentials
      @@profile.credentials
    end

    def config
      @@profile.config
    end

    def endpoints
      @@profile.endpoints
    end
    def profile
      @@profile
    end

    def call(requesth)
      requesth.merge! credentials

      # note: Net::HTTP::Proxy() will return Net::HTTP if PROXY is nil.
      #if (@@profile.m_use_proxy)
        #if( @@pi["USER"].nil? || @@pi["PASSWORD"].nil? )
        #  http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"]).new(endpoints["serverURL"], @@pi["PORT"])
        #else
        #  http = Net::HTTP::Proxy(@@pi["ADDRESS"],@@pi["PORT"],@@pi["USER"], @@pi["PASSWORD"]).new(endpoints["SERVER"], @@pi["PORT"])
        #end
      #else

      transaction = false

      Net::HTTP.start(endpoints["SERVER"],
		      endpoints["PORT"], :use_ssl => true) do |http|

	http.verify_mode    = OpenSSL::SSL::VERIFY_NONE #unless ssl_strict
	http.use_ssl = true;

	req = Net::HTTP::Post.new(endpoints["SERVICE"])
	req.set_form_data(requesth)

	paypallog.info "#{endpoints["SERVER"]}\n"
	paypallog.info "#{Time.now.strftime("%a %m/%d/%y %H:%M %Z")}- SENT:"
	paypallog.info "#{req.body}"

	response = http.request(req)

	paypallog.info "\n"
	paypallog.info "#{Time.now.strftime("%a %m/%d/%y %H:%M %Z")}- RECEIVED:"
	paypallog.info "#{response.body}"

	#case response
	#when Net::HTTPSuccess then
	#  response
	#when Net::HTTPRedirection then
	#  location = response['location']
	#  warn "redirected to #{location}"
	#  fetch(location, limit - 1)
	#else
	#  response.value
	#end

	data = CGI::parse(response.body)
	transaction = Transaction.new(data)
      end
      return transaction
    end

    def paypallog
      self.class.paypallog
    end

    def self.paypallog
      @@PayPalLog ||= Logger.new('log/PayPal.log')
    end
  end


  # Wrapper class to wrap response hash from PayPal as an object and
  # to provide nice helper methods
  class Transaction
    def initialize(data)
     @success = data["ACK"].to_s != "Failure"
     @response = data
   end
    def success?
      @success
    end
    def response
      @response
    end
  end
end

