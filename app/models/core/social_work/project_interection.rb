require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectInterection < ApplicationRecord
      self.table_name = 'generic.social_work_project_interections'
      belongs_to :candidate_project
    end
  end
end
