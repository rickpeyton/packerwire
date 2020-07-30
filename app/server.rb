require "logger"
require "sinatra/base"

class Server < Sinatra::Base
  set :logger, Logger.new(STDOUT)
  set :public_folder, (proc { File.join(root, "public") })
  set :root, File.dirname(__FILE__)
  set :views, (proc { File.join(root, "views") })

  before do
    if !request.body.read.empty? && !request.body.empty?
      request.body.rewind
      @params = Sinatra::IndifferentHash.new
      @params.merge!(JSON.parse(request.body.read))
    end
  end

  get "/" do
    erb :index
  end

  get "/*" do
    status 503

    erb :service_unavialable
  end
end
