require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class ExternalRequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true
      validates :email, email: true, presence: true
      default_scope { where(prefex: 777, subject_id: 1746) }

    end
  end
end
