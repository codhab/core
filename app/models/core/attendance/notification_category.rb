module Core
  module Attendance
    class NotificationCategory < ApplicationRecord
      self.table_name = 'extranet.attendance_notification_categories'
    end
  end
end
