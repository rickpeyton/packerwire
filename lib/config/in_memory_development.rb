require "factory_bot"
require "faker"
require_relative "../../spec/factories/post_factory"

module Config
  class InMemoryDevelopment
    def self.call
      Repository.register(:post, MemoryRepository::PostRepository.new)

      100.times do
        post = Repository.for(:post).new(FactoryBot.attributes_for(:post))
        Repository.for(:post).save(post)
      end
    end
  end
end
