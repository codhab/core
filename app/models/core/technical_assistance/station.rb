module Core
  module TechnicalAssistance
    class Station < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_stations'
      belongs_to :city, required: false, class_name: ::Core::Address::City
    end
  end
end
