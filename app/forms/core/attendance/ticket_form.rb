module Core
  module Attendance
    class TicketForm < Core::Attendance::Ticket

      attr_accessor :return_message

      validates :return_message, presence: true

    end
  end
end
