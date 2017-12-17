module DishesHelper
    def tag_links(tags)
        tags.split(",").map{|tag| link_to tag.strip, filter_path(tag.strip) }.join(", ") 
    end

    def go_to_date(date)
        # if params['date']
        #     params_arr = params['date'].split(',')
        #     params_arr = date
        # end
        # if params['tag']
        # end
        date
    end
end
