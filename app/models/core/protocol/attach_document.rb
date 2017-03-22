require_dependency 'core/application_record'
require_dependency 'core/person/sector'
require_dependency 'core/person/staff'

module Core
  module Protocol
    class AttachDocument < ApplicationRecord
      self.table_name = 'extranet.protocol_attach_documents'

      belongs_to :document_father, required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :document_child,  required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :attach_type,     required: false, class_name: ::Core::Protocol::AttachType
      belongs_to :sector,          required: false, class_name: ::Core::Person::Sector
      belongs_to :staff,           required: false, class_name: ::Core::Person::Staff


      enum :attach_type => [:attach, :append]

    end
  end
end
