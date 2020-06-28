module RackOfLambda
  class SinatraResponse
    def initialize(status:, headers:, raw_body:)
      @status = status
      @headers = headers
      @raw_body = raw_body
    end
  end
end
