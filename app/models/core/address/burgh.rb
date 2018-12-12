require_dependency 'core/application_record'

module Core
  module Address
    class Burgh < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_burghs'
      belongs_to :city, required: false, class_name: ::Core::Address::City
    end
  end
end
