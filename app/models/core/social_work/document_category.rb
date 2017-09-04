require_dependency 'core/application_record'

module Core
  module SocialWork
    class DocumentCategory < ApplicationRecord
      self.table_name = 'generic.social_work_document_categories'
      has_many :document_uploads

      scope :by_type,  -> (type)   {where(type_document: type)}

      enum type_document: ['N/D', 'titular', 'cônjuge', 'documentos_sociais', 'documento_técnico_final']
    end
  end
end
