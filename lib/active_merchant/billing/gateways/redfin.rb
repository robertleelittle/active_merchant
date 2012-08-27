require File.dirname(__FILE__) + '/authorize_net'

module ActiveMerchant #:nodoc:
  module Billing #:nodoc:
    class RedfinGateway < AuthorizeNetGateway
      self.live_url = self.test_url = 'https://payment.redfinnet.com/aim/transact.aspx'
      
      self.homepage_url = 'http://www.redfinnet.com/'
      self.display_name = 'RedfinNetwork'
      
      # Limit support to purchase() for the time being
      # JRuby chokes here
      # undef_method :authorize, :capture, :void, :credit
      
      # undef_method :authorize
      # undef_method :capture
      # undef_method :void
      # undef_method :credit
      
      def test?
        Base.gateway_mode == :test
      end
      
      private
      def split(response)
        response.split(',')
      end
    end
  end
end
