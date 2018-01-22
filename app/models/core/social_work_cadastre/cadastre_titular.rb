module Core
  module SocialWorkCadastre
    class CadastreTitular < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastre_titulars'
      belongs_to :cadastre, class_name: '::SocialWorkCadastre::Cadastre', foreign_key: 'cadastre_id'

      validates :name, presence: true
      validates :cpf, cpf: true, presence: true
    end
  end
end
