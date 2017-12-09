module DishesHelper
    def tag_links(tags)
        puts 'TAGS AFTER FORM'
        puts tags
        tags.split(",").map{|tag| link_to tag.strip, tag_path(tag.strip) }.join(", ") 
    end
end
