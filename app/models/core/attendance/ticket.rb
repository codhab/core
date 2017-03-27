require_dependency 'core/application_record'

module Core
  module Attendance
    class Ticket < ApplicationRecord
      self.table_name = 'extranet.attendance_tickets'

      belongs_to :cadastre,        class_name: Core::Candidate::Cadastre
      belongs_to :cadastre_mirror, class_name: Core::Candidate::CadastreMirror
      belongs_to :context,         class_name: Core::Attendance::TicketContext,   foreign_key: :context_id
      belongs_to :situation,       class_name: Core::Attendance::TicketSituation, foreign_key: :situation_id

      has_many :actions,  class_name: Core::Attendance::TicketAction, foreign_key: :ticket_id
      has_many :comments, class_name: Core::Attendance::TicketComment, foreign_key: :ticket_id
    end
  end
end
