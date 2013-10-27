module ApplicationHelper
  def title(page_title)
    content_for :title, page_title.to_s
  end
  
  def ld(date, options = {})
    if date
      l date, options
    else
      content_tag :em, t("date.never")
    end
  end
end
