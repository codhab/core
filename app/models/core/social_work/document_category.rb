require_dependency 'core/application_record'

module Core
  module SocialWork
    class DocumentCategory < ApplicationRecord
      self.table_name = 'generic.social_work_document_categories'
      has_many :document_uploads
    end
  end
end
