module ApplicationHelper
  def page_title
    base = "StatAp"
    if @title
      return "#{base} | #{@title}"
    else
      return base
    end
  end
end
