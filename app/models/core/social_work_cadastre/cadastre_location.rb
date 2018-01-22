module Core
  module SocialWorkCadastre
    class CadastreLocation < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastre_locations'
      belongs_to :cadastre, class_name: '::SocialWorkCadastre::Cadastre'
      belongs_to :location, class_name: '::SocialWorkCadastre::Location'
    end
  end
end
