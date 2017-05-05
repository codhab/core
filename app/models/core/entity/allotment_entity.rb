require_dependency 'core/application_record'

module Core
  module Entity
    class AllotmentEntity < ApplicationRecord
      self.table_name = 'extranet.entity_allotment_entities'
    end
  end
end