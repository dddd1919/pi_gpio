require "sinatra"
require "erb"

set :views, ['views']

get "/" do
  erb :index
end

get "/gpio" do
  erb :gpio
end

get "/about" do
  erb :about
end