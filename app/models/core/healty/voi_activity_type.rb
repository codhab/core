module Core
  module Healty
    class VoiActivityType < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_activity_types'

      default_scope { where(status: true) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'UnitLabel')
      end
    end
  end
end
