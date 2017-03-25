require_dependency 'core/application_record'

module Core
  module Entity
    class Candidate < ApplicationRecord
      self.table_name = 'extranet.entity_candidates'

      belongs_to :candidate, class_name: ::Core::Candidate::Cadastre
      belongs_to :cadastre, class_name: ::Core::Entity::Cadastre
    end
  end
end
