require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectInteraction < ApplicationRecord
      self.table_name = 'generic.social_work_project_interactions'
      belongs_to :candidate_project
      mount_uploader :document_one, Core::SocialWork::DocumentUploader
      mount_uploader :document_two, Core::SocialWork::DocumentUploader
    end
  end
end
