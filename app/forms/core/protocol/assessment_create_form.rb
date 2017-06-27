require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class AssessmentCreateForm < Core::Protocol::Assessment

      validates :document_type, :subject, :requesting_unit,  presence: true

    end
  end
end
