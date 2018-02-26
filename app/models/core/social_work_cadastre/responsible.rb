require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class Responsible < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_responsibles'
      belongs_to :cadastre_member, required: false, class_name: ::Core::SocialWorkCadastre::CadastreMember, foreign_key: 'members_id'
      belongs_to :cadastre, required: false, class_name: ::Core::SocialWorkCadastre::Cadastre

      def destroy_step(cadastre)
        @step =  Core::SocialWorkCadastre::CadastreStep.where(cadastre_id: cadastre.id, step: 1).last
        if @step.present?
          @step.destroy
        end
      end
    end
  end
end
