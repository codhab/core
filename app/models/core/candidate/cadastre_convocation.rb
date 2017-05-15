require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreConvocation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_convocations'

      belongs_to :convocation, required: false, class_name: ::Core::Candidate::Convocation
      belongs_to :cadastre,    required: false, class_name: ::Core::Candidate::Cadastre

    end
  end
end
