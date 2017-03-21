module Core
  module Sefaz
    class Exemption < ApplicationRecord
      self.table_name = 'extranet.sefaz_exemptions'

      belongs_to :send_status
      belongs_to :staff, class_name: "Person::Staff"
      belongs_to :staff_send, class_name: "Person::Staff"
      belongs_to :allotment

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
