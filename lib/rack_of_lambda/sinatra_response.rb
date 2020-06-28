module RackOfLambda
  class SinatraResponse
    def initialize(status:, headers:, raw_body:)
      @status = status
      @headers = headers
      @raw_body = raw_body
    end

    def apigateway_format
      {
        "statusCode" => @status,
        "headers" => @headers,
        "body" => body
      }
    end

  private

    def body
      body_content = ""
      @raw_body.each do |item|
        body_content += item.to_s
      end
      body_content
    end
  end
end
