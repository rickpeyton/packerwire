require "logger"
require "sinatra/base"

require "active_support/duration"
require "active_support/core_ext/integer/time"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/date_and_time/calculations"
require "active_support/core_ext/date/calculations"

require "aws-sdk-dynamodb"
require "ksuid"

require_relative "models/post"

require_relative "repository"
require_relative "repository/dynamo_repository"
require_relative "repository/dynamo_repository/post_repository"
require_relative "repository/memory_respository"
require_relative "repository/memory_respository/post_repository"

require_relative "../lib/config"

require_relative "views/view_helpers"

class Server < Sinatra::Base
  set :logger, Logger.new(STDOUT)
  set :public_folder, (proc { File.join(root, "assets") })
  set :root, File.dirname(__FILE__)
  set :views, (proc { File.join(root, "views") })

  configure :test do
    Config::InMemoryDevelopment.call
  end

  configure :development do
    Config::DynamoDevelopment.call
    # Config::InMemoryDevelopment.call
  end

  before do
    if !request.body.read.empty? && !request.body.empty?
      request.body.rewind
      @params = Sinatra::IndifferentHash.new
      @params.merge!(JSON.parse(request.body.read))
    end
  end

  get "/" do
    return erb :wip_index if ENV["RACK_ENV"] == "production"

    @posts = Repository.for(:post).latest({ id: params[:last_id], index: params[:last_index] }.compact)
    erb :index
  end

  get "/*" do
    status 503

    erb :service_unavialable
  end
end
