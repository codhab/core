module Core
  module Healty
    class VoiActivity < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_activities'

      belongs_to :voi,           required: false, class_name: 'Core::Healty::Voi'
      belongs_to :activity_type, required: false, class_name: 'Core::Healty::VoiActivityType', foreign_key: 'activity_type_id'

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiActivity')
      end
    end
  end
end
