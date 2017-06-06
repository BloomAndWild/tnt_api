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
