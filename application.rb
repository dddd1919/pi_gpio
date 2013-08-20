require "sinatra"
require "erb"
# require "json"
ON_OFF_SET = ["低电位", "高电位"]

set :views, ['views']

get "/" do
  erb :index
end

get "/gpio" do
  ## 初始化针脚，读取状态后发出信号
  erb :gpio
end

get "/about" do
  erb :about
end

post "/set_pin" do
  set = params["onoff"]
  ## TODO 设置电位
  retval_index = 1 - ON_OFF_SET.index(set)
  ON_OFF_SET[retval_index]
end

get '/get_pin' do
  ## TODO 一次性获取所有针脚状态
end

post '/reset_pin' do
  ## TODO 重置所有针脚状态为输出低电位
end