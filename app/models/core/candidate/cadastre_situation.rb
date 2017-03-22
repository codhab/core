module Core
  module Candidate
    class CadastreSituation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_situations'

      belongs_to :situation_status,      required: false,  ::Core::Candidate::SituationStatus
      belongs_to :cadastre_convocation,  required: false,  ::Core::Candidate::CadastreConvocation
      belongs_to :cadastre,              required: false,  ::Core::Candidate::Cadastre
    end
  end
end
