require_dependency 'core/application_record'
require_dependency 'core/address/state'

module Core
  module Brb
    class Invoice < ApplicationRecord
      self.table_name = 'extranet.brb_invoices'

      belongs_to :category, required: false,    class_name: ::Core::Brb::Category
      belongs_to :state,    required: false,    class_name: ::Core::Address::State

      scope :paids, -> { where(status: 1)}

      enum status: ['não pago', 'pagamento realizado']
      enum invoice_type: ['guia_simples', 'boleto']


      scope :by_name, -> (name) {where('name ilike ?' "%#{name}%")}
      scope :by_cpf, -> (cpf) {where(cpf: cpf.gsub('.','').gsub('-',''))}
      scope :by_type, -> (type) {where(invoice_type: type)}
      scope :by_status, -> (status) {where(status: status)}
      scope :by_category, -> (category) {where(category_id: category)}
      scope :by_date_start, -> (date_start) { where("brb_invoices.created_at::date >= ?", Date.parse(date_start))}
      scope :by_date_end, -> (date_end) { where("brb_invoices.created_at::date <= ?", Date.parse(date_end))}


    end
  end
end
