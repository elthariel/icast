module ScopedCaching
  extend ActiveSupport::Concern

  included do
    Rails.logger.info "#{self} activated ScopedCaching at the Controller level"
    self._caching_scope = {}
  end

  # Generate serialization scope from controller level configuration and
  # adds local method data
  def serialization_scope
    res = self.class._caching_scope.reduce(CachingScope.new) do |scope, pair|
      scope_item = _expand_scope_item(pair.last[:getters])
      unless scope_item.nil?
        scope.add pair.first, scope_item, pair.last[:opts]
      end
      scope
    end.merge!(@_request_caching_scope || CachingScope.new)
    # puts "!!!serialization_scope: #{res.inspect}"
    res
  end

  def caching_scope(key, value, opts = {})
    opts = CachingScope::DEFAULT_OPTIONS.merge opts
    @_request_caching_scope ||= CachingScope.new

    @_request_caching_scope.add key, value, opts
  end

  private
  def _expand_scope_item(getters)
    getters = [getters] unless getters.respond_to? :each

    getters.reduce(self) do |res, getter|
      if res.respond_to? :[] and not res[getter].nil?
        res[getter]
      else
        res = res.__send__(getter) rescue nil
        if res.nil?
          return nil
        else
          res
        end
      end
    end
  end

  module ClassMethods
    attr_accessor :_caching_scope

    def caching_scope(key, getters, opts = {})
      opts = CachingScope::DEFAULT_OPTIONS.merge(opts)

      _caching_scope[key] = { getters: getters, opts: opts }
    end
  end
end
