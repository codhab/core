require_dependency 'core/application_record'
require_dependency 'core/project/user_company'

module Core
  module Candidate
    class EnterpriseCadastreSituation < ApplicationRecord

      self.table_name = 'extranet.candidate_enterprise_cadastre_situations'

      belongs_to :enterprise_situation_status, required: false, class_name: ::Core::Candidate::EnterpriseSituationStatus,  foreign_key: "enterprise_cadastre_status_id"
      belongs_to :enterprise_situation_action, required: false, class_name: ::Core::Candidate::EnterpriseSituationAction,  foreign_key: "enterprise_situation_action_id"
      belongs_to :enterprise_cadastre,         required: false, class_name: ::Core::Candidate::EnterpriseCadastre,
      belongs_to :firm_user,                   required: false, class_name: ::Core::Project::UserCompany,                   foreign_key: "firm_user_id"

      enum type_action: ['contato', 'informação', 'devolução']

    end
  end
end
