require_dependency 'core/application_record'

module Core
  module Entity
    class Candidate < ApplicationRecord
      self.table_name = 'extranet.entity_candidates'

      belongs_to :candidate, class_name: ::Core::Candidate::Cadastre
      belongs_to :cadastre, class_name: ::Core::Entity::Cadastre
      
      def enterprise_cadastre
        ::Core::Candidate::EnterpriseCadastre.where(cadastre_id: self.candidate_id).order(id: :asc).last rescue nil
      end

      def current_situation_name
        situation = ::Core::Candidate::CadastreSituation.where(cadastre_id: self.candidate_id).order(id: :asc).last 
        situation.situation_status.name rescue nil
      end

    end
  end
end
