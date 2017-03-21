module CoreCandidate
  class EnterpriseSituationStatus < ApplicationRecord

    self.table_name = 'extranet.candidate_enterprise_situation_statuses'

    has_many :enterprise_cadastre_situation

  end
end
