module Core
  module SocialWorkCadastre
    class Responsible < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_responsibles'
      belongs_to :cadastre_member, required: false, class_name: '::SocialWorkCadastre::CadastreMember', foreign_key: 'members_id'
      belongs_to :cadastre, required: false, class_name: '::SocialWorkCadastre::Cadastre'
    end
  end
end
