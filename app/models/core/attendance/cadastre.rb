require_dependency 'core/application_record'

module Core
  module Attendance
    class Cadastre < ApplicationRecord
      self.table_name = 'extranet.attendance_cadastres'

      belongs_to :attendant, class_name: ::Core::Person::Staff
      belongs_to :supervisor, class_name: ::Core::Person::Staff
      belongs_to :service_station, class_name: ::Core::Attendance::ServiceStation
      belongs_to :cadastre, class_name: ::Core::Candidate::Cadastre

      enum situation: ['pendente_com_atendente', 'pendente_com_supervisor', 'finalizado', 'cancelado']
      enum situation_cadastre: ['indeferido', 'deferido']
    end
  end
end
