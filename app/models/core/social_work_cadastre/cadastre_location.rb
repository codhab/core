require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class CadastreLocation < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastre_locations'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre
      belongs_to :location, class_name: ::Core::SocialWorkCadastre::Location
    end
  end
end
