require_dependency 'core/application_record'

module Core
  module Document
    class Allotment < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.document_allotments'

      belongs_to :template, class_name: ::Core::Document::Template
      belongs_to :staff,    class_name: ::Core::Person::Staff

      has_many :data_prints,      class_name: ::Core::Document::DataPrint

      validates :template_id, :data_document, presence: true

    end
  end
end
