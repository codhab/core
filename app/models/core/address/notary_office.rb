require_dependency 'core/application_record'

module Core
  module Address
    class NotaryOffice < ApplicationRecord
      self.table_name = 'extranet.address_notary_offices'
      
      belongs_to :unit, required: false
    end
  end
end
