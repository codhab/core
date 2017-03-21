require_dependency 'core/application_record'

module Core
  module Address
    class RegistryUnit < ApplicationRecord
      self.table_name = 'extranet.address_registry_units'

      belongs_to :unit, required: false, class_name: ::Core::Address::Unit

      enum situation: [:não, :em_fase, :sim]

    end
  end
end
