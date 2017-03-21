require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Sefaz
    class Allotment < ApplicationRecord
      self.table_name = 'extranet.sefaz_allotments'

      belongs_to :staff,         required: false,      class_name: ::Core::Person::Staff
      belongs_to :send_status,   required: false,      class_name: ::Core::Sefaz::SendStatus
      belongs_to :send_staff,    required: false,      class_name: ::Core::Person::Staff

      has_many :exemptions

      enum exemption_type: {itbi: 1, itcd: 2}
      enum send_type: ["cancelamento parcial", "pedido de isenção","cancelamento total"]

      scope :protocolo, -> (protocolo) {where(protocol_return: protocolo)}
      scope :date_create, -> (date_create) {where("created_at::date = to_date(?, 'dd/MM/YYYY')", date_create)}
      scope :notifiers, -> (notifiers) {where(notifiers: notifiers)}
      scope :send_status, -> (send_status) {where(send_status_id: send_status)}
      scope :send_type, -> (send_type) {where(send_type: send_type)}
      scope :cpf, -> (cpf) {joins(:exemptions).where('sefaz_exemptions.cpf = ?', cpf.gsub('-','').gsub('.',''))}

    end
  end
end
