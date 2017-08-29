require_dependency 'core/application_record'

module Core
  module SocialWork
    class DocumentCategory < ApplicationRecord
      self.table_name = 'generic.social_work_document_categories'
      has_many :document_uploads

      enum type_document: ['N/D', 'titular', 'cônjuge', 'documentos técnicos', 'documento técnico final']
    end
  end
end
