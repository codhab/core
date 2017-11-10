module Core
  module Attendance
    class TicketForm < Core::Attendance::Ticket

      attr_accessor :return_message, :action_one, :action_two, :action_three, :action_four

      validates :return_message, presence: true

    end
  end
end
