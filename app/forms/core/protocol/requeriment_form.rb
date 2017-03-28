require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class RequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true
      default_scope { where(prefex: 777, subject_id: [1746,1747]) }

    end
  end
end
