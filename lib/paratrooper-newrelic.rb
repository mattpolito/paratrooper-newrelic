require "paratrooper-newrelic/version"
require 'paratrooper/notifier'

module Paratrooper
  module Newrelic

    # Public: Sends notification to NewRelic to stop monitoring while deploy is
    #         happening
    #
    class Notifier < Paratrooper::Notifier
      attr_reader :account_id, :api_key, :application_id

      # Public: Initializes NewRelicNotifier
      #
      # api_key        - String api key from NewRelic
      # account_id     - String NewRelic account id
      # application_id - String NewRelic id of application
      def initialize(api_key, account_id, application_id)
        @api_key        = api_key
        @account_id     = account_id
        @application_id = application_id
      end

      def setup(options = {})
        %x[curl #{core_ping_url('disable')}]
      end

      def teardown(options = {})
        %x[curl #{core_ping_url('enable')}]
      end

      private
      def core_ping_url(type)
        %Q[https://heroku.newrelic.com/accounts/#{account_id}/applications/#{application_id}/ping_targets/#{type} -X POST -H "X-Api-Key: #{api_key}"]
      end
    end
  end
end
