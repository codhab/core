require_dependency 'core/application_record'

module Core
  module Protocol
    class Subject < ApplicationRecord
      self.table_name = 'extranet.protocol_subjects'

      has_many :assessment
    end
  end
end
