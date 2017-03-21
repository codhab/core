require_dependency 'core/application_record'
module Core
  module Address
    class SituationUnit < ApplicationRecord
      self.table_name = 'extranet.address_situation_units'

      has_many :unit

    end
  end
end
