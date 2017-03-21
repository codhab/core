module Core
  module Schedule
    class Agenda < ApplicationRecord
      self.table_name = 'extranet.schedule_agendas'
      
        has_many :agenda_schedules
        belongs_to :program, class_name: "Candidate::Program"

        enum restriction_type: ['nenhuma', 'existente', 'inexistente']

        scope :by_title, -> (value) { where("title ilike '%#{value}%'")}
        scope :by_status, -> (status) { where(status: status)}

        scope :regularization,  -> { where(program: 3)}
        scope :habitation,      -> { where(program: 1)}
        scope :entity,          -> { where(program: 2)}
        scope :active,          -> { where(status: true)}


    end
  end
end
