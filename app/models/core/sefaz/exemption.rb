require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Sefaz
    class Exemption < ApplicationRecord
      self.table_name = 'extranet.sefaz_exemptions'

      belongs_to :send_status,   required: false,      class_name: ::Core::Sefaz::SendStatus
      belongs_to :staff,         required: false,      class_name: ::Core::Person::Staff
      belongs_to :staff_send,    required: false,      class_name: ::Core::Person::Staff
      belongs_to :allotment,     required: false,      class_name: ::Core::Sefaz::Allotment

      enum return: ["Com problemas", "Sem problemas"]

      scope :cpf, -> (cpf) {where(cpf: cpf)}
      scope :return_message, -> (return_message) {
        if return_message == "0"
          where(act_number: '')
        else
          where(return_message: '')
        end
        }
    end
  end
end
