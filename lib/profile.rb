# The module has a class which holds merchant's API credentials and
# PayPal endpoint information.

module PayPalSDKProfiles
  class Profile
    cattr_accessor :endpoints
    cattr_accessor :client_info
    cattr_accessor :proxy_info
    cattr_accessor :client_details

    def headers
      @headers ||= {
        "X-PAYPAL-SERVICE-VERSION" => "1.0.0",
        "X-PAYPAL-SECURITY-USERID"   => config["security_userid"],
        "X-PAYPAL-SECURITY-PASSWORD" => config["security_password"],
        "X-PAYPAL-SECURITY-SIGNATURE"=> config["security_signature"],
        "X-PAYPAL-APPLICATION-ID" => "APP-80W284485P519543T",
        "X-PAYPAL-DEVICE-IPADDRESS"=>"127.0.0.1" ,
        "X-PAYPAL-REQUEST-DATA-FORMAT" => "NV" ,
        "X-PAYPAL-RESPONSE-DATA-FORMAT" => "NV"
      }
    end

    def endpoints
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
      end
      @config
    end

    def m_use_proxy
      @config["USE_PROXY"]
    end
  end

end



