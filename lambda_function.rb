require "json"
require "rack"
require "base64"

require "rack_of_lambda"

APP ||= Rack::Builder.parse_file("#{__dir__}/app/config.ru").first

def lambda_handler(event:, **)
  request = RackOfLambda::SinatraRequest.new(event: event)
  status, headers, body = APP.call(request.env)
  response = RackOfLambda::SinatraResponse.new(status: status, headers: headers, raw_body: body)

  response.apigateway_format
rescue StandardError => e
  { "statusCode" => 500, "body" => e.message }
end
