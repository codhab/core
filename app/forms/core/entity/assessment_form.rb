require_dependency 'core/protocol/assessment'

module Core
  module Entity
    class AssessmentForm < Core::Protocol::Assessment

      validates :description_subject, presence: true

    end
  end
end
