require 'sinatra'
require 'json'
require_relative 'my_user_model'

set :bind, '0.0.0.0'
set :port, 8080

enable :sessions

# 📌 Serve the main HTML file
get '/' do
  send_file File.join(settings.views, 'index.html')
end

# 📌 Route to retrieve all users
get '/users' do
  content_type :json  # Ensure the response is in JSON format
  users = User.all
  users.to_json
end

# 📌 POST route to create a user
post '/users' do
  # puts "🌱 Received params: #{params.inspect}"

  user = {
    firstname: params["firstname"],
    lastname: params["lastname"],
    age: params["age"].to_i,  # 🔥 Convert age to an integer
    email: params["email"] # 🔥 Add email
  }

  # puts "📫 Response sent: #{user.to_json}"
  user.to_json
end

# 📌 POST route for user authentication (sign in)
post '/sign_in' do
  content_type :json

  email = params['email']
  password = params['password']

  # Find user in the database
  user = User.all.find { |u| u.email == email && u.password == password }

  if user
    session[:user_id] = user.id
    response.set_cookie("user_id", value: user.id, path: "/")

    # Return user data (excluding password)
    { id: user.id, firstname: user.firstname, lastname: user.lastname, age: user.age, email: user.email }.to_json
  else
    halt 401, { error: "Invalid email or password" }.to_json
  end
end


# PUT on /users : update password (user must be logged in)
put '/users' do
    content_type :json
    # Check connected user
    halt 401, { error: "Unauthorized" }.to_json unless session[:user_id]
  
    new_password = params["password"]
    halt 400, { error: "Missing password" }.to_json if new_password.nil? || new_password.strip.empty?
  
    # Update current password
    updated_user = User.update(session[:user_id], "password", new_password)
    halt 500, { error: "Failed to update password" }.to_json if updated_user.nil?
  
    # Return user without password
    {
      id: updated_user.id,
      firstname: updated_user.firstname,
      lastname: updated_user.lastname,
      age: updated_user.age,
      email: updated_user.email
    }.to_json
  end
  
  # DELETE on /sign_out : sign out the current user (user must be logged in)
  delete '/sign_out' do
    content_type :json
    # Check connected user
    halt 401, { error: "Unauthorized" }.to_json unless session[:user_id]
  
    # Delete session
    session.clear
    status 204
    ""
  end
  

