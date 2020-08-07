module DynamoRepository
  class PostRepository
    attr_reader :db

    def initialize
      @db = Aws::DynamoDB::Client.new(endpoint: ENV["DYNAMO_HOST"])
    end

    def model_class
      Post
    end

    def new(attributes = {})
      model_class.new(attributes)
    end

    def save(object)
      db.put_item(
        { item: { pk1: "POSTS##{DateTime.parse(object.created_at).strftime('%Y%m')}",
                  sk1: "POST##{KSUID.new(time: DateTime.parse(object.created_at).to_time.to_i)}",
                  created_at: object.created_at,
                  replies: object.replies.to_f,
                  title: object.title,
                  username: object.username },
          table_name: "packerwire" }
      )
      object
    end

    def latest(id: nil, index: DateTime.now.strftime("%Y%m"))
      posts = []
      start_date = index
      while posts.size < 40
        results = query_index(id: id, start_date: start_date)
        results.each { |result| posts << result }
        id = nil
        start_date = (DateTime.strptime(start_date, "%Y%m").to_time - 1.month).strftime("%Y%m")
      end
      posts_results(posts)
    end

  private

    def query_index(id:, start_date:)
      db.query({ expression_attribute_values: index_expression(id: id, start_date: start_date),
                 key_condition_expression: index_condition_expression(id: id),
                 scan_index_forward: false,
                 table_name: "packerwire" }).items
    end

    def index_expression(id:, start_date:)
      return { ":v1" => "POSTS##{start_date}" } unless id

      { ":v1" => "POSTS##{start_date}",
        ":v2" => "POST##{id}" }
    end

    def index_condition_expression(id:)
      return "pk1 = :v1" unless id

      "pk1 = :v1 AND sk1 < :v2"
    end

    def posts_results(posts)
      posts.take(40).map do |item|
        new(
          id: item.dig("sk1").slice(5..-1),
          created_at: item.dig("created_at"),
          replies: item.dig("replies").to_i,
          title: item.dig("title"),
          username: item.dig("username")
        )
      end
    end
  end
end
