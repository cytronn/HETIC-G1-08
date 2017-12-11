class Organization < ApplicationRecord
    belongs_to :user

    def self.all_ids_names
        ids = Organization.all.map { |x| x.id }
        names = Organization.all.map { |x| x.name }
        names.zip(ids).map{|k, v| [k, v]}
    end 
end
