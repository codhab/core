require_dependency 'core/application_record'

module Core
  module Entity
    class SituationStatus < ApplicationRecord
      self.table_name = "extranet.entity_situation_statuses"

    end
  end
end
