# encoding: utf-8
require "rubygems"
require "sinatra"
require "erb"
require "yaml"
require './lib/pi_gpio.rb'
# require "json"
SWITCH = ["低电位","高电位"]
SWITCH_DATA = [:off, :on]
PIN_INFO = YAML::load(File.open("lib/gpio_info.yml"))
PIN = Pi_gpio::Gpio.new(PIN_INFO)

set :views, ['views']

get "/" do
  erb :index
end

## 初始进入控制器直接获取针脚状态
get "/gpio" do
  # PIN_INFO.each { |num, pi| PIN_INFO[num] = pi.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}
  # @pin_status = PIN_INFO
  @pin_status = PIN.read_port_status
  erb :gpio
end

get "/about" do
  erb :about
end

## 这部分接收针脚变化的ajax请求
post "/set_pin" do
  port = params[:id].split[1]
  status = params[:onoff]
  result = status
  unless port.nil?
    PIN.set_port(port, :out, SWIRCH_DATA[1 - SWITCH.index(status)])
    result = SWITCH[1 - SWITCH.index(status)]
  end
  return result
end

## 重置所有接口
post "/reset_pin" do
  PIN.replace_port
  redirect "/gpio"
end

##TODO 端口变为输入时使用长轮询实时刷新前端状态