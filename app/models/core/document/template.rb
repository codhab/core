require_dependency 'core/application_record'

module Core
  module Document
    class Template < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.document_templates'

      validates :page_number, numericality: { greater_than: 0, less_than: 4 }
      validates :name, :title, presence: true
    end
  end
end
