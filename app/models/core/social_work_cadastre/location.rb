module Core
  module SocialWorkCadastre
    class Location < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_locations'
      belongs_to :city, class_name: '::Address::City', foreign_key: 'city_id'
    end
  end
end
