require "json"
require "rack"
require "base64"

require "rack_of_lambda"

APP ||= Rack::Builder.parse_file("#{__dir__}/app/config.ru").first

def lambda_handler(event:, **)
  request = RackOfLambda::SinatraRequest.new(event: event)

  request.headers.each_pair do |key, value|
    name = key.upcase.tr "-", "_"
    header = case name
             when "CONTENT_TYPE", "CONTENT_LENGTH"
               name
             else
               "HTTP_#{name}"
             end
    request.env[header] = value.to_s
  end

  begin
    status, headers, body = APP.call request.env

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
