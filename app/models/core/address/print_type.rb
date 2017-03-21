require_dependency 'core/application_record'

module Core
  module Address
    class PrintType  < ApplicationRecord
      self.table_name = 'extranet.address_print_types'

      has_many :print_allotments

    end
  end
end
