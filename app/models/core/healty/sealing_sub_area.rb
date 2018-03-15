module Core
  module Healty
    class SealingSubArea < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_sealing_sub_areas'

      belongs_to :area,      required: false, class_name: 'Core::Healty::SealingArea',    foreign_key: :area_id
      belongs_to :sub_child, required: false, class_name: 'Core::Healty::SealingSubArea', foreign_key: :sub_area_id

      validates :name, presence: true

      has_many :documents, class_name: 'Core::Healty::SealingDocument', foreign_key: :sub_area_id
      scope :by_name, ->(name) { where('name ilike ?', "%#{name}%") }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SealingSubArea')
      end
    end
  end
end
