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


      def success?(response)
        response[:response_code] == APPROVED
      end

      def fraud_review?(response)
        response[:response_code] == FRAUD_REVIEW
      end



      def split(response)
        puts("Response Text: #{response}")
        response[1,(response.length-2)].split("$,$")
        # response.split('$,$')
      end

      def parse(body)
        fields = split(body)

        results = {
          :response_code => fields[RESPONSE_CODE].to_i,
          :response_reason_code => fields[RESPONSE_REASON_CODE],
          :response_reason_text => fields[RESPONSE_REASON_TEXT],
          :avs_result_code => fields[AVS_RESULT_CODE],
          :transaction_id => fields[TRANSACTION_ID],
          :card_code => fields[CARD_CODE_RESPONSE_CODE],
          :full_body => body
        }
        results
      end
    end
  end
end
