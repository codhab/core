require_dependency 'core/application_record'

module Core
  module Candidate
    class SpecialCondition < ApplicationRecord
      self.table_name = 'extranet.candidate_special_conditions'

    end
  end
end
