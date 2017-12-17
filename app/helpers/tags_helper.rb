module TagsHelper
  def build_tags_url(toggled_tag)
    if params['tags']
      current_tags = params['tags'].split('/')
      if current_tags.include?('all')
        current_tags.delete_at(current_tags.find_index('all'))                    
      end
      if current_tags.include?(toggled_tag.slug) == false
        current_tags.push(toggled_tag.slug)
      else
        current_tags.delete_at(current_tags.find_index(toggled_tag.slug))
      end
      if current_tags.length.zero?
        filters_dishes_path(tags: 'all', date: params['date'] ? params['date'] : 'all')
      else
        current_tags.join('/')
        filters_dishes_path(tags: current_tags, date: params['date'] ? params['date'] : 'all')
      end
    else 
      filters_dishes_path(tags: toggled_tag.slug, date: params['date'] ? params['date'] : 'all' )
    end
  end

  def build_tag_class_name(tag)
    class_name = 'btn btn-sm '
    if params['tags']
      current_tags = params['tags'].split('/')
      current_tags.include?(tag.slug) ? class_name + 'yuumm-btn-primary' : class_name + 'yuumm-btn-outline-primary'
    else
      class_name + 'yuumm-btn-outline-primary'
    end
  end
end
