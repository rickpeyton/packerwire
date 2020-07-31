class Post
  attr_accessor :created_at
  attr_accessor :id
  attr_accessor :replies
  attr_accessor :title
  attr_accessor :username

  def initialize(attributes = {})
    @created_at = attributes.dig(:created_at)
    @replies = attributes.dig(:replies)
    @title = attributes.dig(:title)
    @username = attributes.dig(:username)
  end
end
