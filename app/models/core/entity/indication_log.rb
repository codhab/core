require_dependency 'core/application_record'

module Core
  module Entity
    class IndicationLog < ApplicationRecord
      self.table_name = 'extranet.entity_indication_logs'
    end
  end
end