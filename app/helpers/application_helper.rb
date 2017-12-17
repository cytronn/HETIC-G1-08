module ApplicationHelper
  def current_menu_item?(pathname)
    true if request.path == pathname
  end
end
