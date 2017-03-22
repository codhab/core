require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreOccurrence < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_occurrences'

      belongs_to :occurrence_situation,  required: false
      belongs_to :validation,            required: false, class_name: ::Core::Candidate::Validation
      belongs_to :cadastre,              required: false, class_name: ::Core::Candidate::Cadastre

      scope :solved, ->     { where(solved: true) }
      scope :not_solved, -> { where(solved: false) }


    end
  end
end
