require "logger"
require "sinatra/base"

require_relative "models/post"

require_relative "repository"
require_relative "repository/memory_respository"
require_relative "repository/memory_respository/post_repository"

require_relative "views/view_helpers"

class Server < Sinatra::Base
  set :logger, Logger.new(STDOUT)
  set :public_folder, (proc { File.join(root, "assets") })
  set :root, File.dirname(__FILE__)
  set :views, (proc { File.join(root, "views") })

  configure :test, :development do
    Repository.register(:post, MemoryRepository::PostRepository.new)
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

    require "factory_bot"
    require "faker"
    require_relative "../spec/factories/post_factory"
    50.times do
      post = Repository.for(:post).new(FactoryBot.attributes_for(:post))
      Repository.for(:post).save(post)
    end
    @posts = Repository.for(:post).latest
    erb :index
  end

  get "/*" do
    status 503

    erb :service_unavialable
  end
end
