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

    def raw_env
      {
        "REQUEST_METHOD" => event.dig(:requestContext, :http, :method),
        "SCRIPT_NAME" => "",
        "PATH_INFO" => event.dig(:requestContext, :http, :path),
        "QUERY_STRING" => event.fetch(:rawQueryString, ""),
        "SERVER_NAME" => headers.fetch(:host, "localhost"),
        "SERVER_PORT" => headers.fetch("x-forwarded-port", 443).to_s
      }.merge(rack_env)
    end

  private

    def rack_env
      {
        "rack.version" => Rack::VERSION,
        "rack.url_scheme" => forwarded_proto,
        "rack.input" => StringIO.new(body),
        "rack.errors" => $stderr
      }
    end

    def forwarded_proto
      headers.fetch("CloudFront-Forwarded-Proto") { headers.fetch("X-Forwarded-Proto", "https") }
    end
  end
end
