require "rack"
require "rack/contrib"
require_relative "./server"

set :root, File.dirname(__FILE__)
set :views, (proc { File.join(root, "views") })
set :public_folder, (proc { File.join(root, "public") })

run Sinatra::Application
