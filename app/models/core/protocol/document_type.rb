require_dependency 'core/application_record'

module Core
  module Protocol
    class DocumentType < ApplicationRecord
      self.table_name = 'extranet.protocol_document_types'

      has_many :assessment,  class_name: ::Core::Protocol::Assessment

      default_scope { order('name ASC') }
    end
  end
end
