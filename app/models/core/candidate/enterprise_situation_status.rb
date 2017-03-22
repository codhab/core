require_dependency 'core/application_record'

module Core
  module Candidate
    class EnterpriseSituationStatus < ApplicationRecord
      self.table_name = 'extranet.candidate_enterprise_situation_statuses'

      has_many :enterprise_cadastre_situation

    end
  end
end
