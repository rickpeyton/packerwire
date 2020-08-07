require "pg"
require "pry"

module Config
  class DynamoDevelopment
    def self.call
      config = new
      # config.delete_table
      # config.create_table
      # config.create_posts
    end

    attr_reader :client
    attr_reader :pg

    def initialize
      @client = Aws::DynamoDB::Client.new(endpoint: "http://db:8000")
      @pg = PG::Connection.new(pg_details)
      Repository.register(:post, DynamoRepository::PostRepository.new)
    end

    def create_table
      client.create_table(
        {
          attribute_definitions: [
            {
              attribute_name: "pk1",
              attribute_type: "S"
            },
            {
              attribute_name: "sk1",
              attribute_type: "S"
            }
          ],
          key_schema: [
            {
              attribute_name: "pk1",
              key_type: "HASH"
            },
            {
              attribute_name: "sk1",
              key_type: "RANGE"
            }
          ],
          provisioned_throughput: {
            read_capacity_units: 5,
            write_capacity_units: 5
          },
          table_name: "packerwire"
        }
      )
    end

    def delete_table
      client.delete_table({ table_name: "packerwire" })
    rescue Aws::DynamoDB::Errors::ResourceNotFoundException => e
      Server.logger.debug e
    end

    def create_posts
      posts = get_postgres_posts
      posts.each do |post|
        post_attributes = {
          created_at: DateTime.parse(post.dig("created_at")).iso8601,
          replies: post.dig("reply_count").to_i,
          title: post.dig("title"),
          username: post.dig("username")
        }
        post_object = Repository.for(:post).new(post_attributes)
        Repository.for(:post).save(post_object)
      end
    end

  private

    def get_postgres_posts
      pg = PG::Connection.new(pg_details)

      post_query = <<~SQL
        SELECT t.id as old_id, t.title, u.username, u.id as old_user_id, p.raw, t.created_at, t.updated_at, COUNT(r.topic_id) as reply_count
        FROM topics as t
        LEFT JOIN users as u on u.id = t.user_id
        LEFT JOIN posts as r on r.topic_id = t.id and not r.post_number = 1
        LEFT JOIN posts as p on p.topic_id = t.id and p.post_number = 1
        GROUP BY t.id, t.title, u.username, u.id, p.raw, t.created_at, t.updated_at
        ORDER BY old_id ASC
      SQL

      pg.exec(post_query)
    end

    def pg_details
      pg_details = {
        host: ENV["DB_HOST"],
        dbname: ENV["DB_NAME"],
        user: ENV["DB_USER"],
        password: ENV["DB_PASSWORD"]
      }
    end
  end
end
