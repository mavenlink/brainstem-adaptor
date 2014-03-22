## Ruby Brainstem adapter

Create specification for your API.

```yaml
---
# my_api_service.yml file
users:
  fields:
    name:
      type: "string"
      required: true
    friend_ids:
      type: "array"
    cost:
      type: "integer"
      required: false
    mom_id:
      type: "string"

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
response.results[0]['name']    # returns String
response.results[0].id         # returns String or Integer
response.results[0]['mom']     # returns BrainstemAdaptor::Record
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
