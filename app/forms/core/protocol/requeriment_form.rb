require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class RequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true

    end
  end
end
