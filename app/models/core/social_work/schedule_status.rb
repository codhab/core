require_dependency 'core/application_record'

module Core
  module SocialWork
    class ScheduleStatus < ApplicationRecord
      self.table_name = 'generic.social_work_schedule_statuses'
    end
  end
end
