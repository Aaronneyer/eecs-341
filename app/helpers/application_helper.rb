module ApplicationHelper
  def page_title
    base = "StatApp"
    if @title
      return "#{base} | #{@title}"
    else
      return base
    end
  end
end
