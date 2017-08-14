require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectInteraction < ApplicationRecord
      self.table_name = 'generic.social_work_project_interactions'
      belongs_to :candidate_project
    end
  end
end
