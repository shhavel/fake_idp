# Fake IdP

## Installation

Clone the repo and `cd` into the project directory.

```ruby
bundle install
```

## Running in Development

To run locally, you first need to set up the following environment variables:

```ruby
CALLBACK_URL (the URL of the Healthify app to POST to for SAML authentication - required)
NAME_ID      (name_id of the user you want to log in as - may be nil/blank)
SSO_UID      (unique id of the user you want to log in as - may be nil/blank)
USERNAME     (username of the user you want to log in as - may be nil/blank)
```

The `.env.example` file has examples of what these env variables could look like.
You can copy that over to your own `.env` file to set these environment variables:

    cp .env.example .env

Next, to start the server, you can run:

```ruby
bundle exec rackup
```

Then navigate to `http://localhost:9292/saml/auth` to begin making your SAML requests.

## Running in Test

If you are using this gem to provide a Fake IDP server in a test suite, add the gem
to the Gemfile:

```ruby
gem 'fake_idp', github: 'healthify/fake_idp'
```

You can set the relevant variables in a configuration block if they aren't provided 
as environment variables. For example:

```ruby
FakeIdp.configure do |config|
  config.callback_url = 'http://localhost.dev:3000/auth/saml/devidp/callback'
  config.sso_uid = '12345'
  config.name_id = 'user@example.com'
  config.username = nil
end
```

And then use Capybara Discoball to spin it up in a test:

```ruby
require 'fake_idp'

before(:each) do
  FakeIdp.configure do |config|
    config.callback_url = callback_url
    config.sso_uid = sso_uid
    config.name_id = name_id
  end
end

it 'logs the sso user in' do
  Capybara::Discoball.spin(FakeIdp::Application) do |fake_idp_server|
    # ...
  end
end
```