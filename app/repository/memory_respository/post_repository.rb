module MemoryRepository
  class PostRepository
    def initialize
      @records = []
      @id = 0
    end

    def model_class
      Post
    end

    def new(attributes = {})
      model_class.new(attributes)
    end

    def save(object)
      object.id = @id
      @records[@id] = object
      @id += 1

      object
    end

    def latest(id: nil, index: DateTime.now.strftime("%Y%m"))
      posts = []
      start_date = DateTime.strptime(index, "%Y%m").strftime("%Y-%m")
      while posts.size < 40
        posts << @records.sort_by(&:created_at).reverse.select do |r|
          r.created_at.start_with?(start_date)
        end
        start_date = (DateTime.strptime(start_date, "%Y-%m").to_time - 1.month).strftime("%Y-%m")
      end
      posts.flatten.take(40)
    end
  end
end
