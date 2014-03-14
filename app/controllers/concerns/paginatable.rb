module Paginatable
  PER_PAGE = 25

  def page
    params[:page] || 1
  end

  def page_size
    params[:page_size] || PER_PAGE
  end
end
