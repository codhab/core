module Core
  module Entity
    class ValidateDocument < ActiveRecord::Base # :nodoc:
      self.table_name = 'extranet.entity_validate_documents'
    end
  end
end
