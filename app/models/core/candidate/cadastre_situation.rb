require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreSituation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_situations'

      belongs_to :situation_status,      required: false, class_name: ::Core::Candidate::SituationStatus
      belongs_to :cadastre_convocation,  required: false, class_name: ::Core::Candidate::CadastreConvocation
      belongs_to :cadastre,              required: false, class_name: ::Core::Candidate::Cadastre
      belongs_to :staff,                 required: false, class_name: ::Core::Person::Staff, foreign_key: 'staff_id'
    end
  end
end
