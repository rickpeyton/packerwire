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

    def latest(last = 0)
      @records.sort_by(&:created_at).reverse.slice(last.to_i, 40)
    end
  end
end
