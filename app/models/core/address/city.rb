require_dependency 'core/application_record'

module Core
  module Address
    class City < ApplicationRecord
      self.table_name = 'extranet.address_cities'
      
      belongs_to :state, required: false

      scope :federal_district, -> { joins(:state).where('address_states.acronym = ?', 'DF').order(:name) }
    end
  end
end
