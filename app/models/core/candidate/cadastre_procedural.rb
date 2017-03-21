module Core
  module Candidate
    class CadastreProcedural < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_procedurals'

      belongs_to :procedural_status
      belongs_to :convocation
      belongs_to :cadastre
      belongs_to :assessment, class_name: "CoreCandidate::Protocol::Assessment"
      belongs_to :old_assessment, class_name: "CoreCandidate::Protocol::Assessment", foreign_key: 'old_process', primary_key: "document_number"

    end
  end
end
