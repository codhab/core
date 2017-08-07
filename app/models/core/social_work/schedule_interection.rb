require_dependency 'core/application_record'

module Core
  module SocialWork
    class ScheduleInterection < ApplicationRecord
      self.table_name = 'generic.social_work_schedule_interections'
    end
  end
end
