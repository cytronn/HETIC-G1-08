module TagsHelper
    def go_to_tag(tag)
      if params['tag']
        params_arr = params['tag'].split(',')
        is_in_param = params_arr.find_index(tag)
        params_arr.delete('all')        
        if params_arr.include?(tag) == false
            params_arr.push(tag)
        else
            puts 
            params_arr.delete_at(is_in_param)
            params_arr.join(',')    
        end
        if params_arr.empty? == true
            params_arr.push('all')
        end
        params_arr.join(',')
      else 
        tag
      end
    end
end