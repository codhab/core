require_dependency 'core/application_record'

module Core
  module Address
    class State < ApplicationRecord
      self.table_name = 'extranet.address_states'
    end
  end
end
