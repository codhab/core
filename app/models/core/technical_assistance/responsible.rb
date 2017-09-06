module Core
  module TechnicalAssistance
    class Responsible < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_responsibles'
      belongs_to :station, required: false, class_name: ::Core::TechnicalAssistance::Station

      validates_presence_of :name, :contact, :email
      validates_uniqueness_of :name, :contact, :email
    end
  end
end
