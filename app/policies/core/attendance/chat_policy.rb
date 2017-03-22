module Core
  module Attendance
    class ChatPolicy < ApplicationPolicy

      def allow_create?
        true
      end

    end
  end
end
