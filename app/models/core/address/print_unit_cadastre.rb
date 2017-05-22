require_dependency 'core/application_record'

module Core
  module Address
    class PrintUnitCadastre < ApplicationRecord
      self.table_name = 'extranet.address_print_unit_cadastres'

      belongs_to :cadastre,        required: false,   class_name: ::Core::Candidate::Cadastre
      belongs_to :unit,            required: false,   class_name: ::Core::Address::Unit
      belongs_to :current_unit,    required: false,   class_name: ::Core::Address::Unit
      belongs_to :print_allotment, required: false,   class_name: ::Core::Address::PrintAllotment

    end
  end
end
