require_dependency 'core/application_record'

module Core
  module Address
    class Region < ApplicationRecord
      self.table_name = 'extranet.address_regions'
    end
  end
end
