module Core
  module SocialWorkCadastre
    class CadastreTitular < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_cadastre_titulars'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre, foreign_key: 'cadastre_id'

      validates :name, presence: true
      validates :cpf, cpf: true, presence: true

      def destroy_step(cadastre)
        @step =  Core::SocialWorkCadastre::CadastreStep.where(cadastre_id: cadastre.id, step: 1).last
        if @step.present?
          @step.destroy
        end
      end
    end
  end
end
