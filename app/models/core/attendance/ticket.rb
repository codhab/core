require_dependency 'core/application_record'

module Core
  module Attendance
    class Ticket < ApplicationRecord
      self.table_name = 'extranet.attendance_tickets'

      belongs_to :cadastre,        class_name: Core::Candidate::Cadastre
      belongs_to :cadastre_mirror, class_name: Core::Candidate::CadastreMirror
      belongs_to :context,         class_name: Core::Attendance::TicketContext,   foreign_key: :context_id
      belongs_to :situation,       class_name: Core::Attendance::TicketSituation, foreign_key: :situation_id
      belongs_to :attendant,       class_name: Core::Person::Staff,               foreign_key: :attendant_id
      belongs_to :supervisor,      class_name: Core::Person::Staff,               foreign_key: :supervisor_id


      has_many :actions,       class_name: Core::Attendance::TicketAction,     foreign_key: :ticket_id
      has_many :comments,      class_name: Core::Attendance::TicketComment,    foreign_key: :ticket_id
  
      has_many :uploads, through: :actions, class_name: Core::Attendance::TicketUpload, foreign_key: :action_id      
   
      validate :context_is_valid?

      private

      def context_is_valid?
        
        if !self.context.present?
          errors.add(:context_id, "Contexto ID não é válido")
        end

      end
    end
  end
end
