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
      belongs_to :solicitation_subject, required: false, class_name: 'Core::Regularization::SolicitationSubject', foreign_key: :subject_id

      has_many :solicitation_documents,  class_name: 'Core::Regularization::SolicitationDocument'
      has_many :solicitation_requests,  class_name: 'Core::Regularization::SolicitationRequest'
      has_many :solicitation_answers,  class_name: 'Core::Regularization::SolicitationAnswer'


      scope :by_city,    ->(city)    { where(city_id: city) }
      scope :by_id,      ->(id)      { where(id: id) }
      scope :by_block,   ->(block)   { where(block: block) }
      scope :by_group,   ->(group)   { where(group: group) }
      scope :by_unit,    ->(unit)    { where(unit: unit) }
      scope :by_subject, ->(subject) { where(subject_id: subject) }

      scope :name_reg,     ->(name_reg) { where('name ilike ?', "%#{name_reg}%") }
      scope :address,      ->(address) { where('address ilike ? ', "%#{address}%") }
      scope :address,      ->(address) { joins(:unit).where('address_units.complete_address ilike ?', "%#{address}%") }
      scope :cpf,          ->(cpf) { where(cpf: cpf.gsub('.','').gsub('-','')) }
      scope :date,         ->(date) { where("created_at::date  = ? ", Date.parse(date)) }
      scope :by_situation, ->(situation) {

        uniq = self.map(&:cpf).uniq
          where(answer_status: situation).order(:answer_status)

       }

      validates :email, :name, :content, :city_id, presence: true, on: :create
      validates :cpf, cpf: true, presence: true, on: :create
    end
  end
end
