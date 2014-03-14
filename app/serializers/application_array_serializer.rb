class ApplicationArraySerializer < ActiveModel::ArraySerializer
  cached

  def scope
    options[:scope] || CachingScope.new
  end

  def cache_key
    last_updated = object.map { |i| i.updated_at.to_i }.sort.last
    key = [scope.for_collection, last_updated]

    #puts "Array cache_key = #{key}"
    key
  end
end
