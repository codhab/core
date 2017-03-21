module Core
  module Candidate
    class CadastreOccurrence < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_occurrences'

      belongs_to :occurrence_situation
      belongs_to :validation
      belongs_to :cadastre

      scope :solved, ->     { where(solved: true) }
      scope :not_solved, -> { where(solved: false) }


   end
 end
end
