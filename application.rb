require "sinatra"
require "erb"
# require "json"
ON_OFF_SET = ["3.0V", "0.0V"]

set :views, ['views']

get "/" do
  erb :index
end

get "/gpio" do
  ## 每次请求页面要把端口状态重置
  erb :gpio
end

get "/about" do
  erb :about
end

post "/test" do
  set = params["onoff"]
  retval_index = 1 - ON_OFF_SET.index(set)
  ON_OFF_SET[retval_index]
end