require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreReference < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_references'

    end
  end
end
