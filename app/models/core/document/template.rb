require_dependency 'core/application_record'

module Core
  module Document
    class Template < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.document_templates'

    end
  end
end
