require_dependency 'core/application_record'

module Core
  module Address
    class OwnershipType < ApplicationRecord
      self.table_name = 'extranet.address_ownership_types'

      has_many :unit

    end
  end
end
