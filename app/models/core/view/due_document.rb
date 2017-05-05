require_dependency 'core/application_record'

module Core
  module View
    class DueDocument < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.due_documents'
    end
  end
end
