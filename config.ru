require "sinatra"
require 'faye'

$:<<File.expand_path(File.dirname(__FILE__))
require "application"

##使用faye作为监测后端针脚输入时状态变化的服务，fay根目录使用/faye，所以在sinatra应用下避免使用这个路由!!
use Faye::RackAdapter, :mount   => '/faye',
                       :timeout => 250

# Boot application
## sinatra和faye服务都在同一端口下，路由有区分！
run Sinatra::Application