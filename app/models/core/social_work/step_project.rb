require_dependency 'core/application_record'

module Core
  module SocialWork
    class ScheduleStatus < ApplicationRecord
      self.table_name = 'generic.social_work_step_projects'
      belongs_top :step
    end
  end
end
