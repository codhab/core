require_dependency 'core/application_record'

module Core
  module Entity
    class OldCandidate < ApplicationRecord
      self.table_name = 'extranet.entity_old_candidates'

      belongs_to :old,      required: false, class_name: ::Core::Entity::Old
      belongs_to :cadastre, required: false, class_name: ::Core::Candidate::Cadastre

    end
  end
end
