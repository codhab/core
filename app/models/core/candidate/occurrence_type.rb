require_dependency 'core/application_record'

module Core
  module Candidate
    class OccurrenceType < ApplicationRecord
      self.table_name = 'extranet.candidate_occurrence_types'

    end
  end
end
