module Core
  module Candidate
    class Convocation < ApplicationRecord
      self.table_name = 'extranet.candidate_convocations'

      scope :regularization, -> { where(program_id: 3)}

      has_many :convocation_cadastres

    end
  end
end
