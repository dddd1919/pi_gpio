require "sinatra"
require "slim"

set :views, ['views']

get "/" do
  slim :index
end

get "/gpio" do
  slim :gpio
end