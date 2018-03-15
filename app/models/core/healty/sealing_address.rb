module Core
  module Healty
    class SealingAddress < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_sealing_addresses'

      belongs_to :unit,     required: false, class_name: 'Core::Address::Unit'
      belongs_to :sub_area, required: false, class_name: 'Core::Healty::SubArea'
      belongs_to :city,     required: false, class_name: 'Core::Address::City'

      has_many :documents, class_name: 'Core::Healty::SealingDocument', foreign_key: :address_id

      validates :cpf, :name, :address, :city_id, :sub_area_id, presence: true
      validates :cpf, cpf: true

      scope :by_city,    ->(id)      { where(city_id: id) }
      scope :by_address, ->(address) { where('complete_address ilike ?', "%#{address}%") }
      scope :by_name,    ->(name)    { where('name ilike ?', "%#{name}%") }
      scope :by_cpf,     ->(cpf) { where(cpf: cpf.delete('.').delete('-')) }

      def self.model_name
        ActiveModel::Name.new(self, nil, 'SealingAddress')
      end
    end
  end
end
