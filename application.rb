require "sinatra"
require "slim"

set :views, ['views']

get "/" do
  slim :gpio_index
end