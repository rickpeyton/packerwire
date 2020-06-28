module RackOfLambda
  class SinatraRequest
    attr_reader :event

    def initialize(event:)
      @event = Sinatra::IndifferentHash.new.merge(event)
    end

    def body
      event.fetch(:body, "")
    end

    def headers
      event.fetch(:headers, {})
    end
  end
end
