require_dependency 'core/application_record'

module Core
  module SocialWork
    class DocumentUpload < ApplicationRecord
      self.table_name = 'generic.social_work_document_uploads'
      attr_accessor :type_doc

      belongs_to :document_category
      belongs_to :candidate_project, class_name: 'Core::SocialWork::CandidateProject'

      mount_uploader :document, Core::SocialWork::DocumentUploader
    end
  end
end
