require 'pry-byebug'
require 'sinatra'
require 'sinatra/activerecord'
require_relative 'models/country.rb'

get '/' do
	erb :index
end

post '/submit' do
  @country = Country.new(params[:country])
  if @country.save
    redirect '/country'
  else
    'Sorry, there was an error!'
  end
end

get '/country' do
	@country = Country.all
	erb :countries
end
