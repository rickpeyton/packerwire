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

    def env
      {}.tap do |transformed_env|
        headers.each_pair do |key, value|
          name = key.upcase.tr "-", "_"
          header = case name
                   when "CONTENT_TYPE", "CONTENT_LENGTH"
                     name
                   else
                     "HTTP_#{name}"
                   end
          transformed_env[header] = value.to_s
        end
      end.merge(raw_env)
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
