require 'sinatra'
require 'json'
require_relative 'my_user_model'

set :bind, '0.0.0.0'
set :port, 8080

# POST route to create a user
post '/users' do
    content_type :json
  
    data = params  # Retrieve form data
  
    result = User.create(
      firstname: data['firstname'],
      lastname: data['lastname'],
      age: data['age'].to_i,
      password: data['password'],
      email: data['email']
    )
  
    output = { id: result.id, firstname: result.firstname, lastname: result.lastname, age: result.age, email: result.email }
    
    puts "Response Output: #{output}"  # ✅ Print the output before returning
    
    output.to_json  # Return JSON response
  end
  