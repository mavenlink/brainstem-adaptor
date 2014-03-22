## Ruby Brainstem adapter
[![Build Status](http://travis-ci.org/einzige/brainstem-ruby.png?branch=development)](https://travis-ci.org/einzige/brainstem-ruby)

#### Create specification for your API.
The only thing is missing in Brainstem responses: __associations information__.
Eg having "customer_ids" field does not guarantee that "customer_ids" are related to "customers" collection, it may be stored in "users" collection.
Specification is the thing which describes missing information about responses you receive.
You can also put any additional information you need in your specification (see `projects: :fields` below).

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

### Multiple specifications?

Supported.

```ruby
BrainstemAdaptor::Specification[:my_tracker_api] = { 'users' => {} } # ...
response_data = MyApi.get('/users.json')

response = BrainstemAdaptor::Response.new(response_data, BrainstemAdaptor::Specification[:my_tracker_api])
# ...
```

![http://www.bartleby.com/107/Images/large/image689.gif](http://www.bartleby.com/107/Images/large/image689.gif)
