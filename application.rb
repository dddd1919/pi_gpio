# encoding: utf-8
require "rubygems"
require "sinatra"
require "erb"
require "yaml"
require './lib/pi_gpio.rb'
# require "json"
PIN_INFO = YAML::load(File.open("lib/gpio_info.yml"))
PIN = Pi_gpio::Gpio.new(PIN_INFO)

set :views, ['views']

get "/" do
  erb :index
end

get "/gpio" do
  @pin_status = PIN.read_port_status
  erb :gpio
end

get "/about" do
  erb :about
end

post "/set_pin" do
end

get '/get_pin' do
  ## TODO 一次性获取所有针脚状态
end

post '/reset_pin' do
  ## TODO 重置所有针脚状态为输出低电位
end