require_dependency 'core/application_record'

module Core
  module Project
    class EnterpriseTypology < ApplicationRecord
      self.table_name = 'extranet.project_enterprise_typologies'

      belongs_to :enterprise
      belongs_to :typology, class_name: ::Core::Project::Typology, foreign_key: :typology_id
    end
  end
end
