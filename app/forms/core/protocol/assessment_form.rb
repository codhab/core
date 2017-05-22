require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class AssessmentForm < Core::Protocol::Assessment

      validates :description_subject, presence: true

    end
  end
end
