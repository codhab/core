require_dependency 'core/application_record'

module Core
  module Entity
    class Enterprise < ApplicationRecord
      self.table_name = 'extranet.entity_enterprises'
    end
  end
end
