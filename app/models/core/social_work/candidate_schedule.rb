require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateSchedule < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_schedules'
      belongs_to :schedule_status
      has_many :schedule_interactions
      belongs_to :city,                   required: false,          class_name: ::Core::Address::City
    end
  end
end
