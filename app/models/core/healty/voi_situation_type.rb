module Core
  module Healty
    class VoiSituationType < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_situation_types'

      default_scope { where(status: true) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiSituationType')
      end
    end
  end
end
