require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Protocol
    class DigitalDocument < ApplicationRecord
      self.table_name = 'extranet.protocol_digital_documents'

      belongs_to :assessment, required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :staff,      required: false, class_name: ::Core::Person::Staff

      mount_uploader :doc_path, Core::Protocol::DocumentDigitalUploader

    end
  end
end
