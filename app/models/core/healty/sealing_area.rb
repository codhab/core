module Core
  module Healty
    class SealingArea < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_sealing_areas'

      belongs_to :city, required: false, class_name: 'Core::Address::City'

      has_many :sub_areas, class_name: 'Core::Healty::SealingSubArea',   foreign_key: :area_id
      has_many :documents, class_name: 'Core::Healty::AreaDocumentForm', foreign_key: :area_id

      validates :name, :city_id, presence: true

      scope :by_name, ->(name) { where('name ilike ?', "%#{name}%") }
      scope :by_city, ->(id) { where(city_id: id) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SealingArea')
      end
    end
  end
end
