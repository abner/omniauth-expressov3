# encoding: utf-8
require 'multi_json'
require 'omniauth'

module OmniAuth
  module Strategies
    class ExpressoV3
      include OmniAuth::Strategy

      @@config = {
       :account_id => 'currentAccount::accountId',
       :contact_id =>  'userContact::id',
       :username => 'currentAccount::accountLoginName',
       :name => 'currentAccount::accountFullName',
       :first_name => 'currentAccount::accountFirstName',
       :last_name => 'currentAccount::accountLastName',
       :email => 'currentAccount::accountEmailAddress',
       :telephone => 'userContact::tel_work',
       :organization_unit => 'userContact::org_unit',
       :tine_key => 'keys::tine_key',
       :json_key => 'keys::json_key',
       :cookies => 'keys::cookies'
      }

      option :title, "Autenticação Expresso V3" #default title for authentication form

      option :name, 'expressov3'
      option :fields, [:name, :email]

      option :service_url => OmniAuth::ExpressoV3::AuthClient::SERVICE_URL

      # option :on_login, nil
      # option :on_registration, nil
      # option :on_failed_registration, nil
      # option :locate_conditions, lambda{|req| {model.auth_key => req['auth_key']} }

      def request_phase
        #OmniAuth::Expressov3::AuthClient.validate @options
        f = OmniAuth::Form.new(:title => (options[:title] || "Autenticação Expresso "), :url => callback_path)
        f.text_field 'Login', 'username'
        f.password_field 'Password', 'password'
        f.button "Sign In"
        f.to_response
      end

      def callback_phase
        @auth_client = OmniAuth::ExpressoV3::AuthClient.new @options

        return fail!(:missing_credentials) if missing_credentials?
        begin
          @auth_info = @auth_client.authenticate(request['username'], request['password'])

          return fail!(:invalid_credentials) if !@auth_info

          @expresso_user_info = @auth_client.get_user_data

          @user_info = map_user_data(@expresso_user_info)

          super
        rescue Exception => e
          return fail!(:expressov3_error, e)
        end
      end

      def map_user_data(expresso_user_info)
        self.class.map_user(@@config, expresso_user_info)
      end

      uid {
        @user_info["username"]
      }
      info {
        @user_info
      }
      extra {
        { :raw_info => @expresso_user_info }
      }

      def self.map_user(mapper, object)
        user = {}
        mapper.each do |key, value|
          values_keys = value.split('::')
          value_key = values_keys[0].to_sym
          sub_value_key = values_keys[1].to_sym
          if object && object.respond_to?(value_key) && object.send(value_key) && object.send(value_key).respond_to?(sub_value_key)
            user[key] = object.send(value_key).send(sub_value_key)
          else
            user[key] = nil
          end
        end
        user
      end

      protected

      def missing_credentials?
        request['username'].nil? or request['username'].empty? or request['password'].nil? or request['password'].empty?
      end # missing_credentials?
    end
  end
end

OmniAuth.config.add_camelization 'expressov3', 'ExpressoV3'
