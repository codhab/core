require_dependency 'core/application_record'

module Core
  module Protocol
    class AssessmentSituation < ApplicationRecord
      self.table_name = 'extranet.protocol_assessment_situations'

      belongs_to :staff,      class_name: ::Core::Person::Staff
      belongs_to :assessment, class_name: ::Core::Protocol::Assessment

      enum situation_id: [:review, :finalized]

    end
  end
end
