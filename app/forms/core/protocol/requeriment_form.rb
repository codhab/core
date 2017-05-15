require_dependency 'core/protocol/assessment'

module Core
  module Protocol
    class RequerimentForm < Core::Protocol::Assessment

      validates :observation, presence: true
      default_scope { where(prefex: 777, subject_id: [1746,1747]) }

      scope :by_type, -> (type) {
        if type.to_i == 1
          where(subject_id: 1746)
        end

        if type.to_i == 2
          where(subject_id: 1747)
        end
      }

    end
  end
end
