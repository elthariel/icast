class ActiveRecord::Base
  def cache_key
    "id:#{self.id}:updated_at:#{self.updated_at.to_time.to_i}"
  end
end

class CachedSerializer < ApplicationSerializer
  cached

  def cache_key
    key = [object, scope.for_item]
    #puts "Cache key: #{ActiveSupport::Cache.expand_cache_key key}"
    key
  end
end
