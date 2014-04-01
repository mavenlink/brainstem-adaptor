## Ruby Brainstem Adaptor
[![Build Status](https://travis-ci.org/einzige/brainstem-adaptor.svg?branch=master)](https://travis-ci.org/einzige/brainstem-adaptor)
[![Dependency Status](https://gemnasium.com/einzige/brainstem-ruby.svg)](https://gemnasium.com/einzige/brainstem-ruby)
[![Gem Version](https://badge.fury.io/rb/brainstem-adaptor.svg)](http://badge.fury.io/rb/brainstem-adaptor)

Brainstem Adaptor provides an easy to use interface for [Brainstem](https://github.com/mavenlink/brainstem) API.

```ruby
BrainstemAdaptor.load_specification('my_api_service.yml')
response_data = MyApi.get('/users.json')

# response_data can be a JSON string or Hash
response = BrainstemAdaptor::Response.new(response_data)

response.count                 # returns total count as Integer
# ...
response.results               # returns Array<BrainstemAdaptor::Record>
response.results[0]['friends'] # returns Array<BrainstemAdaptor::Record>

response.results[0]['friends'].last['name']

response.results[0]['name']    # returns String
response.results[0].id         # returns String or Integer
response.results[0]['mom']     # returns BrainstemAdaptor::Record

response.results[0]['mom']['name']
# ...
response['users']              # returns plain Hash as is from response
response['count']              # same here, Integer
```

## Installation

Run:
```bash
gem install brainstem-adaptor
```

Or put in your Gemfile:
```ruby
gem 'brainstem-adaptor'
```

## Configuration
#### Create specification for your API.
The only missing thing in Brainstem responses is an __associations information__.
Having `customer_ids` field does not guarantee that customer ids are related to `customers` collection, those may also be ids of `users` collection.
Specification is the thing which describes missing information about responses you receive.
You can also put any additional information you need in your specification (see details below).

```yaml
---
# my_api_service.yml file
users:
  associations:
    friends:
      foreign_key: friend_ids
      collection: 'users'
    mom:
      foreign_key: mom_id
      collection: 'users'

projects:
  fields:
    name:
      type: string
      required: true
    employee_ids:
      type: array

  associations:
    employees:
      foreign_key: employee_ids
      collection: users
```

### Multiple specifications

You may also have multiple APIs which have different specificaitons.

```ruby
BrainstemAdaptor::Specification[:my_tracker_api] = { 'users' => {} } # ...
response_data = MyApi.get('/users.json')

response = BrainstemAdaptor::Response.new(response_data, BrainstemAdaptor::Specification[:my_tracker_api])
# ...
```

## Contributing

1. Fork
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request (`git pull-request`)

## License

Brainstem Adaptor was created by Mavenlink, Inc. and available under the MIT License.
