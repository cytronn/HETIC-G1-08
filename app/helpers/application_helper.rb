module ApplicationHelper
  def current_menu_item?(pathname, strict = false)
    if strict
      true if request.path == pathname
    else 
      true if request.path.starts_with?(pathname)
    end
  end
end
