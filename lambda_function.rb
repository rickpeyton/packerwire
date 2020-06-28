require "json"
require "rack"
require "base64"

require "rack_of_lambda"

APP ||= Rack::Builder.parse_file("#{__dir__}/app/config.ru").first

def lambda_handler(event:, **)
  request = RackOfLambda::SinatraRequest.new(event: event)
  status, headers, body = APP.call(request.env)
  response = RackOfLambda::SinatraResponse.new(status: status, headers: headers, raw_body: body)

  body_content = ""
  body.each do |item|
    body_content += item.to_s
  end

  {
    "statusCode" => status,
    "headers" => headers,
    "body" => body_content
  }
rescue StandardError => e
  {
    "statusCode" => 500,
    "body" => e.message
  }
end
