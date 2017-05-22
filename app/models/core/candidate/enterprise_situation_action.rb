require_dependency 'core/application_record'

module Core
  module Candidate
    class EnterpriseSituationAction < ApplicationRecord
      self.table_name = 'extranet.candidate_enterprise_situation_actions'

    end
  end
end
