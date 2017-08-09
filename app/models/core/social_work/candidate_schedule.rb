require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateSchedule < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_schedules'
      belongs_to :schedule_status
      has_many :schedule_interections
    end
  end
end
