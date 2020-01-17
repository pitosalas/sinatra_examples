require 'sinatra'
require "sinatra/activerecord"
require 'byebug'
require_relative "models/user"

get '/' do
  "Hello Sinatra!"
end

# Lookup a certain user
get '/api/users/:name' do
  user = User.find_by_name(params[:name])
  pp user
  if user
    user.to_json
  else
    error 404, {error: "user not found"}.to_json
  end
end

# Creater a new user
post "/api/users" do
  user = User.create(JSON.parse(request.body.read))
  pp user

  if user.valid?
    user.to_json
  else
    error 400, user.errors.to_json
  end
rescue => e
  error 400, e.messages.to_json
end

