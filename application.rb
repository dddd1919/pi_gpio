# encoding: utf-8
require "rubygems"
require "sinatra"
require "erb"
require "yaml"
require 'net/http'
require 'uri'
require 'lib/pi_gpio.rb'
require "json"
SWITCH = ["低电位","高电位"]
SWITCH_DATA = [:off, :on]
PIN_WATCH_THREAD = {}
PIN_INFO = YAML::load(File.open("lib/gpio_info.yml"))
PIN = Pi_gpio::Gpio.new(PIN_INFO)

set :views, ['views']

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
    retval = watch_pin(params[:pin])
  else
    retval = unwatch_pin(params[:pin])
  end
  return retval.to_s
end

def watch_pin(pin)
  retval  = false
  new_watch_thread = watch :pin => pin do
    ## post pin changing message to faye server
    params = {}
    uri = URI.parse("http://localhost:3000/faye")
    params["message"] = {"channel" => "/messages/new", "data" => {"pin" => pin, "switch" => SWITCH[value]}}.to_json
    response = Net::HTTP.post_form(uri, params)
    retval = JSON.parse(response.body)[0]["successful"]
  end
  ## save thread message to PIN_WATCH_THREAD
  PIN_WATCH_THREAD[pin] = new_watch_thread
  return true
end

def unwatch_pin(pin)
  retval = false
  unless PIN_WATCH_THREAD[pin].nil?
    PIN_WATCH_THREAD[pin].kill ## kill watch thread
    retval = !PIN_WATCH_THREAD.delete(pin).nil?
  end
  return retval
end