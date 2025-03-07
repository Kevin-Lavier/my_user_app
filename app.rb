require 'sinatra'
require 'json'
require_relative 'my_user_model'

set :bind, '0.0.0.0'
set :port, 8080

# POST route to create a user
post '/users' do
  content_type :json

  data = if request.media_type == 'application/json'
           request_body = request.body.read
           JSON.parse(request_body)
         else
           params
         end

  puts "Parsed data: #{data.inspect}"

  firstname = data['firstname'].to_s
  lastname  = data['lastname'].to_s
  password  = data['password'].to_s
  email     = data['email'].to_s
  age       = data['age'].to_i

  result = User.create(
    firstname: firstname,
    lastname:  lastname,
    age:       age,
    password:  password,
    email:     email
  )

  if result.is_a?(Hash) && result.key?(:error)
    puts "Error Output: #{result}"
    return result.to_json
  end

  output = {
    id:        result.id,
    firstname: result.firstname,
    lastname:  result.lastname,
    age:       result.age,
    email:     result.email
  }

  puts "Response Output: #{output}"

  output.to_json
end
