
require_relative '../service'
require 'rspec'
require 'rack/test'
require 'byebug'

set :environment, :test

describe "service" do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  before(:each) do
    User.delete_all
  end

  describe "GET on /api/v1/users/:id" do
    before(:each) do
      User.create(
        name: "paul",
        email: "paul@pauldix.net",
        password: "strongpass",
        bio: "rubyist")
    end

    it "should return a user by name" do
      get '/api/v1/users/paul'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["name"]).to eql("paul")
    end

    it "should return a user with an email" do
      get '/api/v1/users/paul'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["email"]).to eql("paul@pauldix.net")
    end

    it "should not return a user's password" do
      get '/api/v1/users/paul'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes).not_to have_key("password")
    end

    it "should return a user with a bio" do
      get '/api/v1/users/paul'
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["bio"]).to eql("rubyist")
    end

    it "should return a 404 for a user that doesn't exist" do
      get '/api/v1/users/foo'
      expect(last_response.status).to eql(404)
    end
  end

  describe "POST on /api/v1/users" do
    it "should create a user" do
      post '/api/v1/users',
          {name: "trotter",
           email: "no spam",
           password: "whatever",
           bio: "southern belle"}.to_json
      expect(last_response).to be_ok

      get '/api/v1/users/trotter'
      attributes = JSON.parse(last_response.body)
      expect(attributes["name"]).to eq("trotter")
      expect(attributes["email"]).to eq("no spam")
      expect(attributes["bio"]).to eq("southern belle")
    end
  end

  describe "PUT on /api/v1/users/:id" do
    it "should update a user" do
      User.create(name: "bryan", email: "no spam", password: "whatever", bio: "rspec master")
      put '/api/v1/users/bryan', {bio: "testing freak"}.to_json
      expect(last_response).to be_ok
      get '/api/v1/users/bryan'
      attributes = JSON.parse(last_response.body)
      expect(attributes["bio"]).to eq("testing freak")
    end
  end

  describe "DELETE on /api/v1/users/:id" do
    it "should delete a user" do
      User.create(
        name: "francis",
        email: "no spam",
        password: "whatever",
        bio: "williamsburg hipster")
      delete '/api/v1/users/francis'
      expect(last_response).to be_ok
      get '/api/v1/users/francis'
      expect(last_response.status).to eq(404)
    end
  end

  describe "POST on /api/v1/users/:id/sessions" do
    before do
      User.create(name: "josh", password: "nyc.rb rules")
    end

    it "should return the user object on valid credentials" do
      post '/api/v1/users/josh/sessions', {password: "nyc.rb rules"}.to_json
      expect(last_response).to be_ok
      attributes = JSON.parse(last_response.body)
      expect(attributes["name"]).to eq("josh")
    end

    it "should fail on invalid credentials" do
      post '/api/v1/users/josh/sessions', {password: "wrong"}.to_json
      expect(last_response.status).to eq(400)
    end
  end
end
