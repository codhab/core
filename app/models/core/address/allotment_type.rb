require_dependency 'core/application_record'

module Core
  module Address
    class AllotmentType < ApplicationRecord
      self.table_name = 'extranet.address_allotment_types'
      
      has_many :print_allotments

    end
  end
end
