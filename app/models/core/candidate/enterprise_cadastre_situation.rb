module CoreCandidate
  class EnterpriseCadastreSituation < ApplicationRecord

    self.table_name = 'extranet.candidate_enterprise_cadastre_situations'

    belongs_to :enterprise_situation_status, foreign_key: "enterprise_cadastre_status_id"
    belongs_to :enterprise_situation_action, foreign_key: "enterprise_situation_action_id"
    belongs_to :enterprise_cadastre, class_name: "CoreCandidate::EnterpriseCadastre"
    belongs_to :firm_user, class_name: "CoreCandidate::Project::UserCompany", foreign_key: "firm_user_id"

    enum type_action: ['contato', 'informação', 'devolução']

  end
end
