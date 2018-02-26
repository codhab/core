require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class CadastreMember < ApplicationRecord
        self.table_name = 'portal.social_work_cadastre_cadastre_members'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre, foreign_key: 'cadastre_id'
      has_many :responsibles, class_name: ::Core::SocialWorkCadastre::Responsible

      validates :name, :cpf, :telephone, presence: true
      validates :cpf, cpf: :true, presence: true

      def destroy_step(cadastre)
        @step =  Core::SocialWorkCadastre::CadastreStep.where(cadastre_id: cadastre.id, step: 1).last
        if @step.present?
          @step.destroy
        end
      end
    end
  end
end
