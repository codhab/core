require_dependency 'core/application_record'

module Core
  module SocialWork
    class StepProject < ApplicationRecord
      self.table_name = 'generic.social_work_step_projects'

      belongs_to :step
      belongs_to :project
    end
  end
end
