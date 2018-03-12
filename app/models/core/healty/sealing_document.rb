module Core
  module Healty
    class SealingDocument < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_sealing_documents'

      belongs_to :address,  required: false, class_name: 'Core::Healty::SealingAddress'
      belongs_to :area,     required: false, class_name: 'Core::Healty::SealingArea'
      belongs_to :sub_area, required: false, class_name: 'Core::Healty::SealingSubArea'

      validates :attachment, presence: true

      mount_uploader :attachment, Core::Healty::DocumentUploader

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SealingDocument')
      end
    end
  end
end
