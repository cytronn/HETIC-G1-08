class Organization < ApplicationRecord
    has_many :users

    def self.all_ids_names
        ids = Organization.all.map { |x| x.id }
        names = Organization.all.map { |x| x.name }
        names.zip(ids).map{|k, v| [k, v]}
    end 

    validates :name, presence: true
    validates :address, presence: true
end
