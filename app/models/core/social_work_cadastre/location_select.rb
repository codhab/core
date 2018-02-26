require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class LocationSelect < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_location_selects'
      belongs_to :city, class_name: ::Core::Address::City, foreign_key: 'city_id'
    end
  end
end
