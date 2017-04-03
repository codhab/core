require_dependency 'core/application_policy'

module Core
  module Attendance
    class Attendant < ApplicationRecord
      self.table_name = 'extranet.attendance_attendants'

      belongs_to :staff, required: false, class_name: ::Core::Person::Staff

      enum privilege: ['atendente', 'supervisor']

    end
  end
end
