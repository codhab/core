require_dependency 'core/application_record'
require_dependency 'core/address/unit'

module Core
  module Regularization
    class Solicitation < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitations'
      belongs_to :unit,          required: false, class_name: 'Core::Address::Unit', foreign_key: :unit_id
      belongs_to :city,          required: false, class_name: 'Core::Address::City'

      scope :by_city,     ->(city)    { where(city_id: city) }
    end
  end
end