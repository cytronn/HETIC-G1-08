module TagsHelper
  def build_tags_url(toggled_tag)
    if params['tags']
      current_tags = params['tags'].split('/')
      if current_tags.include?(toggled_tag.slug) == false
        current_tags.push(toggled_tag.slug)
      else
        current_tags.delete_at(current_tags.find_index(toggled_tag.slug))
      end
      if current_tags.length.zero?
        dishes_path
      else
        current_tags.join('/')
        tags_dishes_path(current_tags)
      end
    else 
      tags_dishes_path(toggled_tag.slug)
    end
  end

  def build_tag_class_name(tag)
    class_name = 'btn btn-sm '
    if params['tags']
      current_tags = params['tags'].split('/')
      current_tags.include?(tag.slug) ? class_name + 'yuumm-btn-outline-primary' : class_name + 'yuumm-btn-primary'
    else
      class_name + 'yuumm-btn-primary'
    end
  end
end
