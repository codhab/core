require_dependency 'core/application_record'

module Core
  module SocialWork
    class ScheduleInteraction < ApplicationRecord
      self.table_name = 'generic.social_work_schedule_interactions'
      belongs_to :candidate_schedule
    end
  end
end
