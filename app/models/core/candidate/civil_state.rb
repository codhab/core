require_dependency 'core/application_record'

module Core
  module Candidate
    class CivilState < ApplicationRecord
      self.table_name = 'extranet.candidate_civil_states'

    end
  end
end
