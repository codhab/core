require_dependency 'core/application_record'

module Core
  module SocialWork
    class DocumentUpload < ApplicationRecord
      self.table_name = 'generic.social_work_document_uploads'
      belongs_to :document_category
    end
  end
end
