module Core
  module Healty
    class VoiDocument < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_voi_documents'

      belongs_to :voi, required: false, class_name: 'Core::Healty::Voi'

      validates :attachment, :name, presence: true

      mount_uploader :attachment, Core::Healty::DocumentUploader

      def self.model_name
        ActiveModel::Name.new(self, nil, 'VoiDocument')
      end
    end
  end
end
