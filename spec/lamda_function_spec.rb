require_relative "../lambda_function"

RSpec.describe "Lambda Function" do
  describe "#lambda_handler" do
    it "has a 200 status code" do
      actual = lambda_handler(event: event_fixture)

      expect(actual.dig("statusCode")).to eq 200
    end

    it "has a body that includes the PackerWire index" do
      actual = lambda_handler(event: event_fixture)

      expect(actual.dig("body")).to include("PackerWire Index")
    end
  end
end

def event_fixture
  {
    "version": "2.0",
    "routeKey": "ANY /{proxy+}",
    "rawPath": "/",
    "rawQueryString": "",
    "headers": {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "en-us",
      "content-length": "0",
      "host": "gp27wx8ay2.execute-api.us-east-1.amazonaws.com",
      "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Safari/605.1.15",
      "x-amzn-trace-id": "Root=1-5ef7d277-0316c5a226e1aacce35772a9",
      "x-forwarded-for": "99.160.140.87",
      "x-forwarded-port": "443",
      "x-forwarded-proto": "https"
    },
    "requestContext": {
      "accountId": "392957558567",
      "apiId": "gp27wx8ay2",
      "domainName": "gp27wx8ay2.execute-api.us-east-1.amazonaws.com",
      "domainPrefix": "gp27wx8ay2",
      "http": {
        "method": "GET",
        "path": "/",
        "protocol": "HTTP/1.1",
        "sourceIp": "99.160.140.87",
        "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1.1 Safari/605.1.15"
      },
      "requestId": "Oz3SwjSooAMEPtw=",
      "routeKey": "ANY /{proxy+}",
      "stage": "$default",
      "time": "27/Jun/2020:23:12:55 +0000",
      "timeEpoch": 1593299575911
    },
    "pathParameters": {
      "proxy": ""
    },
    "isBase64Encoded": false
  }
end
