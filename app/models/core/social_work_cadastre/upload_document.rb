require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class UploadDocument < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_upload_documents'
      belongs_to :document_type, class_name: ::Core::SocialWorkCadastre::DocumentType, foreign_key: 'document_type_id'
      belongs_to :cadastre, class_name: ::Core::SocialWorkCadastre::Cadastre, foreign_key: 'cadastre_id'

      mount_uploader :file_path, Core::SocialWorkCadastre::FilePathUploader

      validates :file_path, :document_type_id, presence: true
    end
  end
end
