class CachingScope
  DEFAULT_OPTIONS = {
    collection: true,
    item:       true
  }

  attr_reader :caching_scope

  def initialize
    @caching_scope = Hash.new
  end

  def for_item
    filter_scope { |_, v| v[:opts][:item] }
  end

  def for_collection
    filter_scope { |_, v| v[:opts][:collection] }
  end

  def add(key, value, opts = {})
    @caching_scope[key] = {
      value: value,
      opts:  DEFAULT_OPTIONS.merge(opts)
    }
  end

  def merge!(other_scope)
    @caching_scope.merge! other_scope.caching_scope
    self
  end

  private
  def filter_scope(&block)
    @caching_scope.dup.keep_if(&block).map { |k, v| [k, v[:value]] }
  end
end
