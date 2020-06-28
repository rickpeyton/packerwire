require "rack"
require "rack/contrib"

require_relative "./server"

require "logger"

set :root, File.dirname(__FILE__)
set :views, (proc { File.join(root, "views") })
set :public_folder, (proc { File.join(root, "public") })

set :logger, Logger.new(STDOUT)

run Sinatra::Application
