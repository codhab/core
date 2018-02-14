module Core
  module SocialWorkCadastre
    class CadastreStep < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastre_steps'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre
    end
  end
end
