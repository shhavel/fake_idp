# frozen_string_literal: true

require_relative "./saml_response"
require "ruby-saml"
require "pry"

module FakeIdp
  class Application < Sinatra::Base
    include SamlIdp::Controller

    get "/saml/auth" do
      issuer = configuration.issuer
      configuration.issuer = issuer.slice(0..(issuer.index('metadata') + 8)) + params[:idp_key]
      @configuration = configuration

      erb :sso
    end

    post "/auth" do
      configuration.issuer = params[:issuer]
      configuration.email = params[:email]
      @configuration = configuration
      decode_SAMLRequest(generate_saml_request)
      @saml_response = Base64.encode64(build_xml_saml_response).delete("\r\n")

      erb :auth
    end

    get "/trust/saml2/http-redirect/slo/:slo_id" do
      @http_referer = request.env['HTTP_REFERER']

      erb :slo
    end

    private

    def configuration
      FakeIdp.configuration
    end

    def build_xml_saml_response
      FakeIdp::SamlResponse.new(
        name_id: configuration.name_id,
        issuer_uri: configuration.issuer,
        audience_uri: configuration.audience,
        saml_acs_url: @saml_acs_url, # Defined in #decode_SAMLRequest in ruby-saml-idp gem
        saml_request_id: @saml_request_id, # Defined in #decode_SAMLRequest in ruby-saml-idp gem
        user_attributes: user_attributes,
        algorithm_name: configuration.algorithm,
        certificate: configuration.idp_certificate,
        secret_key: configuration.idp_secret_key,
        encryption_enabled: configuration.encryption_enabled,
      ).build
    end

    def user_attributes
      {
        uuid: configuration.sso_uid,
        username: configuration.username,
        first_name: configuration.first_name,
        last_name: configuration.last_name,
        email: configuration.email,
        name: configuration.get_name_from_email,
        roles: configuration.roles,
      }.merge(configuration.additional_attributes)
    end

    # An AuthRequest is required by the ruby-saml-idp gem to begin the process of returning
    # a SAMLResponse. We will likely remove the ruby-saml-idp dependency in a future update
    def generate_saml_request
      auth_request = OneLogin::RubySaml::Authrequest.new
      auth_url = auth_request.create(saml_settings)
      CGI.unescape(auth_url.split("=").last)
    end

    def saml_settings
      OneLogin::RubySaml::Settings.new.tap do |setting|
        setting.assertion_consumer_service_url = configuration.callback_url
        # setting.issuer = configuration.issuer
        setting.issuer = 'https://localhost:9292/saml/metadata/11111111-1111-1111-1111-111111111111'
        setting.idp_sso_service_url = configuration.idp_sso_service_url
        setting.name_identifier_format = FakeIdp::SamlResponse::EMAIL_ADDRESS_FORMAT
      end
    end
  end
end
