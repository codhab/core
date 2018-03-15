require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class Observation < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_observations'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre, foreign_key: 'cadastre_id'

      validates :observation, presence: true

      
    end
  end
end
