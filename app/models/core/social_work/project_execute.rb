require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectExecute < ApplicationRecord
      self.table_name = 'generic.social_work_project_executes'

      belongs_to :company
      belongs_to :project
      belongs_to :staff
    end
  end
end
