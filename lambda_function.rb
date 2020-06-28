require "json"
require "rack"
require "base64"

require "rack_of_lambda"

APP ||= Rack::Builder.parse_file("#{__dir__}/app/config.ru").first

def lambda_handler(event:, **)
  request = RackOfLambda::SinatraRequest.new(event: event)

  # Rack expects the querystring in plain text, not a hash
  headers = request.event.fetch "headers", {}

  # Environment required by Rack (http://www.rubydoc.info/github/rack/rack/file/SPEC)
  env = {
    "REQUEST_METHOD" => request.event.dig("requestContext", "http", "method"),
    "SCRIPT_NAME" => "",
    "PATH_INFO" => request.event.dig("requestContext", "http", "path"),
    "QUERY_STRING" => request.event.fetch("rawQueryString", ""),
    "SERVER_NAME" => headers.fetch("host", "localhost"),
    "SERVER_PORT" => headers.fetch("x-forwarded-port", 443).to_s,

    "rack.version" => Rack::VERSION,
    "rack.url_scheme" => headers.fetch("CloudFront-Forwarded-Proto") { headers.fetch("X-Forwarded-Proto", "https") },
    "rack.input" => StringIO.new(request.body),
    "rack.errors" => $stderr
  }

  # Pass request headers to Rack if they are available
  headers.each_pair do |key, value|
    # 'CloudFront-Forwarded-Proto' => 'CLOUDFRONT_FORWARDED_PROTO'
    # Content-Type and Content-Length are handled specially per the Rack SPEC linked above.
    name = key.upcase.tr "-", "_"
    header = case name
             when "CONTENT_TYPE", "CONTENT_LENGTH"
               name
             else
               "HTTP_#{name}"
             end
    env[header] = value.to_s
  end

  begin
    # Response from Rack must have status, headers and body
    status, headers, body = APP.call env

    # body is an array. We combine all the items to a single string
    body_content = ""
    body.each do |item|
      body_content += item.to_s
    end

    response = {
      "statusCode" => status,
      "headers" => headers,
      "body" => body_content
    }

    response["isBase64Encoded"] = false if request.event["requestContext"].key?("elb")
  rescue Exception => e # rubocop:disable Lint/RescueException
    response = {
      "statusCode" => 500,
      "body" => e.message
    }
  end

  response
end
