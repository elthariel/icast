class KaminariSerializer < ActiveModel::ArraySerializer
  def initialize(object, options = {})
    super

    if object.respond_to? :current_page
      options[:meta] = {
        current_page: object.current_page,
        total_page: object.num_pages,
        total_count: object.total_count,
        page_size: object.limit_value
      }.merge options[:meta] || {}
    end
  end
end
