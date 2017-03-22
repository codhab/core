require_dependency 'core/application_record'
require_dependency 'core/address/city'
require_dependency 'core/schedule/agenda'

module Core
  module Schedule
    class AgendaSchedule < ApplicationRecord
      self.table_name = 'extranet.schedule_agenda_schedules'

        belongs_to :city,    required: false,  class_name: ::Core::Address::City
        belongs_to :agenda,  required: false,  class_name: ::Core::Schedule::Agenda

        enum status: ['agendado', 'liberado_para_retorno', 'cancelado', 'finalizado_sem_retorno']


    end
  end
end
