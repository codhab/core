require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Protocol
    class Workflow < ApplicationRecord
      self.table_name = 'extranet.protocol_workflows'

      belongs_to :assessment
      belongs_to :attachment, class_name: Core::Protocol::Assessment
      
    end
  end
end