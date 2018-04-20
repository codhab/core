require_dependency 'core/application_record'
require_dependency 'core/address/unit'

module Core
  module Regularization
    class Solicitation < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitations'
      attr_accessor :by_block
      attr_accessor :by_unit
      attr_accessor :by_group

      belongs_to :unit,          required: false, class_name: 'Core::Address::Unit', foreign_key: :unit_id
      belongs_to :city,          required: false, class_name: 'Core::Address::City'
      belongs_to :solicitation_subject, required: false, class_name: 'Core::Regularization::SolicitationSubject'

      has_many :solicitation_documents,  class_name: 'Core::Regularization::SolicitationDocument'

      scope :by_city,  ->(city)  { where(city_id: city) }
      scope :by_block, ->(block) { where(block: block) }
      scope :by_group, ->(group) { where(group: group) }
      scope :by_unit,  ->(unit)  { where(unit: unit) }


      validates :cpf, :email, :name, :content, :city_id, presence: true
    end
  end
end
