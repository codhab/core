module Core
  module TechnicalAssistance
    class Station < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_stations'
    end
  end
end
