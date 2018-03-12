module Core
  module Healty
    class UnitImage < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_unit_images'

      mount_uploader :image, Core::Healty::ImageUploader

      def self.model_name
        ActiveModel::Name.new(self, nil, 'UnitImage')
      end
    end
  end
end
