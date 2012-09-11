# The module has a class which holds merchant's API credentials and
# PayPal endpoint information.

module PayPalSDKProfiles
  class Profile
    cattr_accessor :endpoints
    cattr_accessor :client_info
    cattr_accessor :proxy_info
    cattr_accessor :client_details

    def credentials
      return nil unless config
      @credentials ||= {
        "USER"     => config["security_userid"],
        "PWD"      => config["security_password"],
        "SIGNATURE"=> config["security_signature"],
        "VERSION"  => "63.0"
      }
    end

    def endpoints
      return nil unless config
      # endpoint of PayPal server against which call will be made.
      @endpoints ||= {
        "SERVER"  => config["nvp_server"],
        "PORT"    => config["nvp_port"],
        "SERVICE" => config["nvp_service"],
      }
    end

    #Client details to be send in request
    @@client_details ={"ipAddress"=>"127.0.0.1", "deviceId"=>"mydevice", "applicationId"=>"APP-80W284485P519543T"}


    # Proxy information of the client environment.
    @@proxy_info = {
      "USE_PROXY" => false,
      "ADDRESS" => nil,
      "PORT" => "443",
      "USER" => nil,
      "PASSWORD" => nil
    }

    # Information needed for tracking purposes.
    @@client_info = {
      "VERSION" => "64.0",
      "SOURCE" => "PayPalRubySDK kate V2.0.0"
    }

    def initialize
      config
    end

    def config
      unless @config
        yaml = YAML.load_file("#{::Rails.root.to_s}/config/paypal.yml")
        @config = yaml[RAILS_ENV]
	raise Exception unless @config
      end
      @config
    end

    def m_use_proxy
      @config["USE_PROXY"]
    end
  end

end



