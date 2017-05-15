require_dependency 'core/application_record'

module Core
  module Candidate
    class SpecialConditionType < ApplicationRecord
      self.table_name = 'extranet.candidate_special_condition_types'

    end
  end
end
