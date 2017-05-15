require_dependency 'core/application_record'

module Core
  module Candidate
    class Dependent < ApplicationRecord
      self.table_name = 'extranet.candidate_dependents'

      belongs_to :cadastre,           required: false, class_name: ::Core::Candidate::Cadastre
      belongs_to :civil_state,        required: false, class_name: ::Core::Candidate::CivilState
      belongs_to :kinship,            required: false, class_name: ::Core::Candidate::Kinship
      belongs_to :special_condition,  required: false, class_name: ::Core::Candidate::SpecialCondition

      enum gender: ['N/D', 'masculino', 'feminino']
    end
  end
end
