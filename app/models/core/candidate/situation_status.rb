module CoreCandidate
  class SituationStatus <  ApplicationRecord

    self.table_name = 'extranet.candidate_situation_statuses'

    enum status: ['ok', 'pendente','cinza','nao_sabemos']


  end
end
