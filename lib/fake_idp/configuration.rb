module FakeIdp
  class Configuration
    attr_accessor(
      :callback_url,
      :sso_uid,
      :username,
      :first_name,
      :last_name,
      :email,
      :name_id,
      :roles,
      :certificate,
      :idp_certificate,
      :idp_secret_key,
      :idp_sso_service_url,
      :issuer,
      :audience,
      :algorithm,
      :additional_attributes,
      :encryption_enabled,
    )

    X509_CERTIFICATE = "-----BEGIN CERTIFICATE-----
MIICdjCCAd+gAwIBAgIBADANBgkqhkiG9w0BAQsFADBXMQswCQYDVQQGEwJ1YTEN
MAsGA1UECAwES3lpdjEUMBIGA1UECgwLdGhyZWRVUC1kZXYxFDASBgNVBAMMC3Ro
cmVkdXAuY29tMQ0wCwYDVQQHDARLeWl2MCAXDTIyMDExMzE4Mzk0OFoYDzIxMjEx
MjIwMTgzOTQ4WjBXMQswCQYDVQQGEwJ1YTENMAsGA1UECAwES3lpdjEUMBIGA1UE
CgwLdGhyZWRVUC1kZXYxFDASBgNVBAMMC3RocmVkdXAuY29tMQ0wCwYDVQQHDARL
eWl2MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCz5DnwPPHVg7QCY1TKQ74
LgSyqHd9Hl33CEUw/yLu6HqX8OcgjMlzYGrUujfjgPg3mxOh3GpZoqfXn4wU7zx7
0TiJamwAysbCZakIIG98asnQrw/KCMvhoBaNbNZiQz2us10UuAiaJGQWRqN9UwXe
39iSprxXDD33d45k3eTfVwIDAQABo1AwTjAdBgNVHQ4EFgQUuuLboJF4ARhsDhEL
a0Kcyng/RSMwHwYDVR0jBBgwFoAUuuLboJF4ARhsDhELa0Kcyng/RSMwDAYDVR0T
BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOBgQAaVuFtaHzOkVOIiNgXiORHO8wd2gqq
cIqnVXN/kz77vhORheneDGah6sUxqlS5NMEyEMTUmysyaZHOuYm3hSr6gTr0Lfof
OJfg1VXHs8ed7V/RAmshSobHBD3kPA3iimxLYV9W5+TKth8ATnIdprfV0BVYJe/+
CbKWLgSOyluRZg==
-----END CERTIFICATE-----"

    SECRET_KEY = "-----BEGIN PRIVATE KEY-----
MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAMLPkOfA88dWDtAJ
jVMpDvguBLKod30eXfcIRTD/Iu7oepfw5yCMyXNgatS6N+OA+DebE6Hcalmip9ef
jBTvPHvROIlqbADKxsJlqQggb3xqydCvD8oIy+GgFo1s1mJDPa6zXRS4CJokZBZG
o31TBd7f2JKmvFcMPfd3jmTd5N9XAgMBAAECgYARDCbrEOiEThSXwe47E8G6mBRT
KgjiyxB/+JpNclY1P+TSfQNMxuUuEobmvLD9WKDgBNMP/ADWfTRg2xZgEpthN1HE
QlAvQKQrtUSO6BxZaDhzECJSNyGh+94TMsmT2RD1d3T/YxbkgDcMoSop20YC4fNT
x4IgDYMygKQOjeaJeQJBAOUgebXEU8aalCeqZK5NL6t5yvvyBzwxHSfemrj7N+GC
vLBLiqe//sQfqQaM3e2vS/NueV6Ea43p/x86b1Lw2xsCQQDZqMCl3CUlOweQ4Dto
tDLrx1PVyHEXVe4jq9Nq1ooaGDcjUjoc2+5l9NgD7OKOi41vSMQeqh+8f3JwDO5b
ofR1AkBVei0Nm2VphQdaWN3gjJkJDpGkNiFu2h+3XPs5oTayoXRFDJl4hU7E2c7T
y7+LSUc7VG5gzWPWeIIdo04ekg4bAkEAmAUKEI3Sj89LuH80XyvEiPLd9emaOy80
NUvUTMFtEU6qbAwJNJDTT/iTSyKPFfoYHYqYF8bAhboJ5oLRk8Ro5QJBAN7A/KLf
OXfCREF880sbKJ+rZJuR5Tdstnnut0xlGA0wzqjjK4Tz5ni6p2gUBFol0RKeLb5d
tVVxToueDmgtWM4=
-----END PRIVATE KEY-----"

    def initialize
      @callback_url = ENV['CALLBACK_URL']
      @sso_uid = ENV['SSO_UID']
      @username = ENV['USERNAME']
      @first_name = ENV['FIRST_NAME']
      @last_name = ENV['LAST_NAME']
      @email = ENV.fetch('EMAIL', 'john.doe@thredup.com')
      @name_id = ENV.fetch('NAME_ID', @email)
      @certificate = default_certificate
      @idp_certificate = default_idp_certificate
      @idp_secret_key = default_idp_secret_key
      @idp_sso_service_url = ENV['IDP_SSO_SERVICE_URL']
      @issuer = ENV['ISSUER']
      @audience = ENV['AUDIENCE']
      @algorithm = default_algorithm
      @additional_attributes = JSON.load(ENV['ADDITIONAL_ATTRIBUTES']) || {}
      @encryption_enabled = default_encryption
      @roles = ENV['ROLES']
    end

    def get_name_from_email
      (@email[/^[^@]+/] || '').split('.').map(&:titleize).join(' ') if @email
    end

    private

    def default_certificate
      ENV["CERTIFICATE"] ||
        SamlIdp::Default::X509_CERTIFICATE
    end

    def default_idp_certificate
      ENV["IDP_CERTIFICATE"] || X509_CERTIFICATE
    end

    def default_idp_secret_key
      ENV["IDP_SECRET_KEY"] || SECRET_KEY
    end

    def default_algorithm
      ENV["ALGORITHM"]&.to_sym || :sha256
    end

    def default_encryption
      ENV["ENCRYPTION_ENABLED"] == "true"
    end
  end
end
