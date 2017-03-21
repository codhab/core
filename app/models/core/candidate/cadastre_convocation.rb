module CoreCandidate
  class CadastreConvocation < ApplicationRecord
    self.table_name = 'extranet.candidate_cadastre_convocations'

    belongs_to :convocation
    belongs_to :cadastre


  end
end
