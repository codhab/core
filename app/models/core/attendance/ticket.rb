require_dependency 'core/application_record'

module Core
  module Attendance
    class Ticket < ApplicationRecord
      self.table_name = 'extranet.attendance_tickets'

      belongs_to :cadastre,        class_name: Core::Candidate::Cadastre
      belongs_to :cadastre_mirror, class_name: Core::Candidate::CadastreMirror
      belongs_to :convocation,     class_name: Core::Candidate::CadastreConvocation
      belongs_to :ticket_context
      belongs_to :ticket_status
      belongs_to :ticket_type

      has_many :ticket_uploads
      has_many :ticket_comments
      has_many :ticket_context_actions


    end
  end
end
