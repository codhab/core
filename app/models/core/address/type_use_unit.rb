require_dependency 'core/application_record'

module Core
  module Address
    class TypeUseUnit  < ApplicationRecord
      self.table_name = 'extranet.address_type_use_units'

    end
  end
end
