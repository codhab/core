require_dependency 'core/application_record'

module Core
  module Candidate
    class DependentMirror < ApplicationRecord
      self.table_name = 'extranet.candidate_dependent_mirrors'

      belongs_to :special_condition,       required: false,  class_name: ::Core::Candidate::SpecialCondition
      belongs_to :civil_state,             required: false,  class_name: ::Core::Candidate::CivilState
      belongs_to :kinship,                 required: false,  class_name: ::Core::Candidate::Kinship
      belongs_to :special_condition_type,  required: false,  class_name: ::Core::Candidate::SpecialConditionType
      belongs_to :cadastre_mirror,         required: false,  class_name: ::Core::Candidate::CadastreMirror
      belongs_to :dependent,               required: false,  class_name: ::Core::Candidate::Dependent, foreign_key: :dependent_id
       
      enum gender: ['N/D', 'masculino', 'feminino']

      def age
        self.born.present? ? (Date.today - self.born).to_i / 365 :  0
      end

      def income
        self[:income].present? ? '%.2f' % self[:income] : 0 
      end

    end
  end
end
