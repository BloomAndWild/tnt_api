# Tnt Api

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/tnt_api`. To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tnt_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tnt_api

## Usage

TNTApi::RequestHandler.request(request_name, attributes)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Usage

### client configuration (if using Rails, place in an initializer)

```
TNTApi::Client.configure do |config|
  config.username = # your username
  config.password = # your password
  config.service_endpoint = # your service_endpoint
  config.service_wsdl = # your service_wsdl
  config.logger = # your logger
  config.account_number = # your account_number
end
```

### Expedition Creation (create shipment) request

```
TNTApi::RequestHandler.request(
  :expedition_creation,
  attributes,
)
```

Sender attributes:

sender_name
sender_address_line1
sender_address_line2
sender_zip_code
sender_city
sender_contact_first_name
sender_contact_last_name
sender_email
sender_phone

recipient attributes:

first_name
last_name
address_line1
address_line2
zip_code
city
email
phone
access_code
building_id
floor_number
instructions
notify_receiver

expedition attributes:

service_code
saturday_delivery
shipping_date
weight

### Tracking by consignment (tracking using parcel number) request

```
TNTApi::RequestHandler.request(
  :tracking_by_consignment,
  { parcel_number: "9412345000000025" },
)
```

### Error handling

If a request fails, a `TNTApi::TNTError` will be raised.
You can call `.message` on this object to get the error messages from TNT.

You can also call `.attributes` to get the formatted values passed to TNT for debugging.

NOTE: Characters unsupported by the TNT Api are encoded to HTML entities which can push strings over the character limit.
