require_dependency 'core/application_record'

module Core
  module Schedule
    class Agenda < ApplicationRecord
      self.table_name = 'extranet.schedule_agendas'
        belongs_to :program,  required: false, class_name: ::Core::Candidate::Program

        enum restriction_type: ['nenhuma', 'existente', 'inexistente']

    end
  end
end
