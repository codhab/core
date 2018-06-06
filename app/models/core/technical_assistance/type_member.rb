module Core
  module TechnicalAssistance
    class TypeMember < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_type_members'

      validates_presence_of :name
      validates_uniqueness_of :name
    end
  end
end
