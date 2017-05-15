require_dependency 'core/application_record'

module Core
  module Entity
    class AllotmentUnit < ApplicationRecord
      self.table_name = 'extranet.entity_allotment_units'

    end
  end
end