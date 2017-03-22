module Core
  module Candidate
    class CadastreOccurrence < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_occurrences'

      belongs_to :occurrence_situation,  required: false, ::Core::Candidate::Occurrence
      belongs_to :validation,            required: false, ::Core::Candidate::Validation
      belongs_to :cadastre,              required: false, ::Core::Candidate::Cadastre

      scope :solved, ->     { where(solved: true) }
      scope :not_solved, -> { where(solved: false) }


   end
 end
end
