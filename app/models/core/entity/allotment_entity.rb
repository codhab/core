require_dependency 'core/application_record'

module Core
  module Entity
    class AllotmentEntity < ApplicationRecord
      self.table_name = 'extranet.entity_allotment_entities'

      belongs_to :entity, class_name: ::Core::Entity::Cadastre, foreign_key: :entity_id

    end
  end
end
