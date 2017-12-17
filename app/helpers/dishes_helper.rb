module DishesHelper
  def tag_links(tags)
    tags.split(',').map{ |tag|
      link_to tag.strip, tag_path(tag.strip)
    }.join(', ')
  end

  def build_date_url(date)
    if params['date']
      if params['date'].include?(date)
        filters_dishes_path(params['tags'] ? params['tags'] : 'all', 'all')
      else               
        filters_dishes_path(params['tags'] ? params['tags'] : 'all', date) 
      end      
  else
    filters_dishes_path(params['tags'] ? params['tags'] : 'all', date)         
  end
  end

  def build_date_class_name(date)
    class_name = 'btn btn-sm '
    if params['date']
      current_date = params['date']
      current_date.include?(date) ? class_name + 'yuumm-btn-primary' : class_name + 'yuumm-btn-outline-primary'
    else
      class_name + 'yuumm-btn-outline-primary'
    end
  end
end
