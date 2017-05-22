require_dependency 'core/application_record'

module Core
  module Candidate
    class Program < ApplicationRecord
      self.table_name = 'extranet.candidate_programs'

      has_many :positions

      def validations
        Core::Candidate::Validation.where("'#{self.id}' = ANY(program_id)")
      end
    end
  end
end
