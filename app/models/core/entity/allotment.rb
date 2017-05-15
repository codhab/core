require_dependency 'core/application_record'

module Core
  module Entity
    class Allotment < ApplicationRecord
      self.table_name = 'extranet.entity_allotments'

      has_many :allotment_units
      has_many :allotment_entities
      has_many :indication_units

    end
  end
end