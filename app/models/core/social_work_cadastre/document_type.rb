module Core
  module SocialWorkCadastre
    class DocumentType < ApplicationRecord
      self.table_name = 'portal.social_work_cadastre_document_types'
      validates :name, presence: true
    end
  end
end
