module Core
  module Healty
    class VoiSituation < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_situations'

      belongs_to :voi,            required: false, class_name: 'Core::Healty::Voi'
      belongs_to :situation_type, required: false, class_name: 'Core::Healty::VoiSituationType'

      validates :situation_type_id, presence: true

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiSituation')
      end
    end
  end
end
