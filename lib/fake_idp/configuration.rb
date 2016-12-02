module FakeIdp
  class Configuration
    attr_accessor :callback_url, :sso_uid, :username, :first_name, :last_name, :email, :name_id
    def initialize
      @callback_url = ENV['CALLBACK_URL']
      @sso_uid = ENV['SSO_UID']
      @username = ENV['USERNAME']
      @first_name = ENV['FIRST_NAME']
      @last_name = ENV['LAST_NAME']
      @email = ENV['EMAIL']
      @name_id = ENV['NAME_ID']
    end
  end
end