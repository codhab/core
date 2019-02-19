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
      enum right_of_use_type: ['Usufruto', 'Usufruto_vitalício']

      def age
        ((Date.today - self.born).to_i / 365.25).to_i rescue I18n.t(:no_information)
      end
    end
  end
end
