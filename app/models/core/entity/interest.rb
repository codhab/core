require_dependency 'core/application_record'

module Core
  module Entity
    class Interest < ApplicationRecord
      self.table_name = 'extranet.entity_interests'

      belongs_to :unit_sale, class_name: ::Core::Address::City
      belongs_to :entity,    class_name: ::Core::Entity::Cadastre, foreign_key: :entity_id

    end
  end
end
