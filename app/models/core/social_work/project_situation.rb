require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectSituation < ApplicationRecord
      self.table_name = 'generic.social_work_project_situations'
      has_many :candidate_projects
    end
  end
end
