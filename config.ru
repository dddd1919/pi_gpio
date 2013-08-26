require "sinatra"

$:<<File.expand_path(File.dirname(__FILE__))
require "application"

# Boot application
run Sinatra::Application