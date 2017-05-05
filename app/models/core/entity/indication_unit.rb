require_dependency 'core/application_record'

module Core
  module Entity
    class IndicationUnit < ApplicationRecord
      self.table_name = 'extranet.entity_indication_units'

      belongs_to :unit, class_name: ::Core::Address::Unit
      belongs_to :allotment, class_name: ::Core::Entity::Allotment      
      belongs_to :cadastre, class_name: ::Core::Candidate::Cadastre


      has_many :indication_logs, class_name: ::Core::Entity::IndicationLog, foreign_key: :indication_unit_id

      enum situation: ['indicado_para_entidade', 'candidato_selecionado', 'candidato_indicado']

      def indicate_candidate!
        
      end

    end
  end
end