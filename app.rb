require 'sinatra'
require 'json'
require_relative 'my_user_model'

set :bind, '0.0.0.0'
set :port, 8080

# POST route to create a user
post '/users' do
    content_type :json
  
    data = params
  
    result = User.create(
    firstname: data['firstname'],
    lastname:  data['lastname'],
    age:       data['age'].to_i,
    password:  data['password'],
    email:     data['email']
  )


  if result.is_a?(Hash) && result.key?(:error)
    "Error Output: #{result}"
    return result.to_json
  end

  output = { 
    id:        result.id, 
    firstname: result.firstname, 
    lastname:  result.lastname, 
    age:       result.age, 
    email:     result.email 
  }

  "Response Output: #{output}"

  output.to_json
  end
  