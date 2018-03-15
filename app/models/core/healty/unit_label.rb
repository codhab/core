module Core
  module Healty
    class UnitLabel < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_unit_labels'

      belongs_to :unit,  required: false, class_name: 'Core::Address::Unit'
      belongs_to :label, required: false, class_name: 'Core::Healty::Label'

      def self.model_name
        ActiveModel::Name.new(self, nil, 'UnitLabel')
      end
    end
  end
end
