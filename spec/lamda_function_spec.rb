require_relative "../lambda_function"

RSpec.describe "Lambda Function" do
  describe "#lambda_handler" do
    it "has a 200 status code" do
      actual = lambda_handler(event: event_fixture)

      expect(actual.dig("statusCode")).to eq 200
    end

    it "has a body that includes the PackerWire index" do
      actual = lambda_handler(event: event_fixture)

      expect(actual.dig("body")).to match(/PackerWire.+Index/m)
    end

    context "for resources not yet mapped" do
      it "returns a 503" do
        actual = lambda_handler(event: service_unavailable_fixture)

        expect(actual.dig("statusCode")).to eq 503
      end

      it "has a custom 503 page" do
        actual = lambda_handler(event: service_unavailable_fixture)

        expect(actual.dig("body")).to match(/Content temporarily unavailable/m)
      end
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
      "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15" \
        "(KHTML, like Gecko) Version/13.1.1 Safari/605.1.15",
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
        "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_5) AppleWebKit/605.1.15" \
          "(KHTML, like Gecko) Version/13.1.1 Safari/605.1.15"
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

def service_unavailable_fixture
  {
    "version": "2.0",
    "routeKey": "ANY /{proxy+}",
    "rawPath": "/unavailable_path.html",
    "rawQueryString": "",
    "headers": {
      "accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
      "accept-encoding": "gzip, deflate, br",
      "accept-language": "en-us",
      "content-length": "0",
      "host": "gp27wx8ay2.execute-api.us-east-1.amazonaws.com",
      "user-agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)" \
        "Version/13.1.2 Safari/605.1.15",
      "x-amzn-trace-id": "Root=1-5f230ad4-9dfbd3519952bc90709b3127",
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
        "path": "/blah.html",
        "protocol": "HTTP/1.1",
        "sourceIp": "99.160.140.87",
        "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_6) AppleWebKit/605.1.15 (KHTML, like Gecko)" \
          "Version/13.1.2 Safari/605.1.15"
      },
      "requestId": "Qf6hQgf6oAMEMgw=",
      "routeKey": "ANY /{proxy+}",
      "stage": "$default",
      "time": "30/Jul/2020:18:00:52 +0000",
      "timeEpoch": 1596132052748
    },
    "pathParameters": { "proxy": "unavailable_path.html" },
    "isBase64Encoded": false
  }
end
