module Core
  module Healty
    class VoiOriginType < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_origin_types'

      default_scope { where(status: true) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiOriginType')
      end
    end
  end
end
