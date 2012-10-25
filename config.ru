require File.join(File.dirname(__FILE__),"monitor_server")
disable :run
set :root, Pathname(__FILE__).dirname
run Sinatra::Application

