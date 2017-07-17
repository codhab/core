require_dependency 'core/application_record'

module Core
  module Entity
    class UnitSale < ApplicationRecord
      self.table_name = 'extranet.entity_unit_sales'

      belongs_to :city, class_name: ::Core::Address::City

      has_many :interests, class_name: ::Core::Entity::Interest
    end
  end
end
