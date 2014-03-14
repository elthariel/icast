class KaminariSerializer < ApplicationArraySerializer
  def initialize(object, options = {})
    super object, options

    # Kaminari pagination
    if object.respond_to? :current_page
      options[:meta] = {
        current_page: object.current_page,
        total_page: object.num_pages,
        total_count: object.total_count,
        page_size: object.limit_value
      }.merge options[:meta] || {}
    # Tire pagination
    elsif object.respond_to? :options and object.options.has_key? :size
      options[:meta] = {
        current_page: object.options[:from] / object.options[:size],
        total_page: object.total / object.options[:size],
        total_count: object.total,
        page_size: object.options[:size]
      }.merge options[:meta] || {}
    end
  end
end
