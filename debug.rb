require 'net/http'
require 'faye'
require 'uri'
require "json"

params = {}
uri = URI.parse("http://localhost:3000/faye")
params["message"] = {"channel" => "/messages/new", "data" => {"pin" => 15, "switch" => "高电位"}}.to_json
response = Net::HTTP.post_form(uri, params)