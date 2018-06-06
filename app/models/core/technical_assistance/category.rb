module Core
  module TechnicalAssistance
    class Category < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_categories'

      validates_presence_of :name
      validates_uniqueness_of :name
    end
  end
end
