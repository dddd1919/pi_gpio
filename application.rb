# encoding: utf-8
require "rubygems"
require "sinatra"
require "erb"
require "yaml"
require "socket"
require 'lib/pi_gpio.rb'
require "json"
SWITCH = ["低电位","高电位"]
SWITCH_DATA = [:off, :on]
PIN_WATCH_THREAD = {}
PIN_INFO = YAML::load(File.open("lib/gpio_info.yml"))
PIN = Pi_gpio::Gpio.new(PIN_INFO)

configure do
  set :views, ['views']
  set :faye_local_host, Socket.ip_address_list[1].ip_address
end


get "/" do
  erb :index
end

## Init pin info from config file and Raspberry
get "/gpio" do
  # PIN_INFO.each { |num, pi| PIN_INFO[num] = pi.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}}
  # @pin_status = PIN_INFO
  @pin_status = PIN.read_port_status
  erb :gpio
end

get "/about" do
  erb :about
end

## receive Pin ajax request from client
post "/set_pin" do
  port = params[:id]
  status = params[:onoff]
  result = status
  unless port.nil?
    PIN.set_port(port, :out, SWITCH_DATA[1 - SWITCH.index(status)])
    result = SWITCH[1 - SWITCH.index(status)]
  end
  return result
end

## reset all Pin
post "/reset_pin" do
  PIN.replace_port
  redirect "/gpio"
end

post "/inout_switch" do
  retval = false
  if params[:direction].to_s == "in"
    retval = PIN.watch_pin(params[:pin])
  else
    retval = PIN.unwatch_pin(params[:pin])
  end
  return retval.to_s
end