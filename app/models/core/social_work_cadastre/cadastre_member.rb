module Core
  module SocialWorkCadastre
    class CadastreMember < ApplicationRecord
        self.table_name = 'portal.social_work_cadastre_cadastre_members'
      belongs_to :cadastre, class_name: '::SocialWorkCadastre::Cadastre', foreign_key: 'cadastre_id'
      has_many :responsibles, class_name: '::SocialWorkCadastre::Responsible'

      validates :name, :cpf, :telephone, presence: true
      validates :cpf, cpf: :true, presence: true
    end
  end
end
