module Translator
  class RedisStore
    def initialize(redis)
      @redis = redis
    end

    def keys
      @redis.keys
    end

    def []=(key, value)
      value = nil if value == '' || value.nil?
      @redis[key] = ActiveSupport::JSON.encode(value)
    end

    def [](key)
      @redis[key]
    end

    def destroy_entry(key)
      @redis.del key
    end

    def clear_database
      @redis.keys.clone.each {|key| @redis.del key }
    end
  end
end

