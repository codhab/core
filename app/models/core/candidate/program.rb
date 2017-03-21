module CoreCandidate
  class Program < ApplicationRecord

    self.table_name = 'extranet.candidate_programs'

    has_many :positions

    def validations
      CoreCandidate::Validation.where("'#{self.id}' = ANY(program_id)")
    end
  end
end
