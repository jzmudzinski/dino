require 'digest/sha2'
require 'base64'

module Api
  class AllegroWebAPI
    CONFIG = {
      wsdl: "https://webapi.allegro.pl/service.php?wsdl",
      webapi_key: "cd5f9c022",
      username: "czendler",
      password: "Dinozaury3",
      country_id: 1
    }

    attr_reader :session

    def initialize
      @client = Savon.client(
        # The WSDL document provided by the service.
        :wsdl => CONFIG[:wsdl],

        # Lower timeouts so these specs don't take forever when the service is not available.
        :open_timeout => 10,
        :read_timeout => 10,

        # Disable logging for cleaner spec output.
        :log => false
      )

      @webapi_key = CONFIG[:webapi_key]
      # @session = session
    end

    def session
      @session ||= login(CONFIG[:username], CONFIG[:password])[:session_handle_part]
    end

    def soap_actions
      @client.wsdl.soap_actions
    end

    def invoke(action, parameters)
      # parameters["webapiKey"] = @webapi_key
      begin
        response = @client.call action, message: parameters
      rescue Exception => e
        @session = nil
        response = @client.call action, message: parameters
      end
      response.to_hash
    end

    def get_sys_status
      invoke(:do_query_sys_status, {
        'sysvar' => 1,
        'countryId' => CONFIG[:country_id],
        'webapiKey' => CONFIG[:webapi_key]
      })[:do_query_sys_status_response]
    end

    def login(username, password)
      invoke(:do_login_enc, {
        'userLogin' => username,
        'userHashPassword' => (Digest::SHA2.new << password).base64digest,
        'countryCode' => CONFIG[:country_id],
        'webapiKey' => CONFIG[:webapi_key],
        'localVersion' => self.get_sys_status[:ver_key]
      })[:do_login_enc_response]
    end

    def get_item_info(item_id)
      invoke(:do_show_item_info_ext, {
        'sessionHandle' => session,
        'itemId' => item_id,
        #'get-image-url' => 1
      })[:do_show_item_info_ext_response]
    end

    def get_many_item_info(item_ids)
      ids = item_ids.uniq
      invoke(:do_get_items_info, {
        'sessionHandle' => session,
        'itemsIdArray' => {
          'item' => ids
        },
        'getImageUrl' => 1
      })[:do_get_items_info_response]
    end

    def doGetItemsInfoForCoupons(item_ids)
      ids = item_ids.uniq
      invoke(:do_get_items_info_for_coupons, {
        # 'session-handle' => session,
        'items-id-array' => {
          'item' => ids
        },
        'get-image-url' => 1,
        :attributes! => {
          'items-id-array' => {
            'xsi:type' => "SOAP-ENC:Array",
            'SOAP-ENC:arrayType' => "xsd:long[#{ids.length}]"
          }
        }
      })[:do_get_items_info_for_coupons_response]
    end

    def get_my_data
      invoke(:do_get_my_data, {
        'session-handle' => session
      })[:do_get_my_data_response]
    end

    def get_site_journal
      invoke(:do_get_site_journal, {
        'sessionHandle' => session,
        'infoType' => 1
      })[:do_get_site_journal_response]
    end

  end
end
