require_dependency 'core/attendance/document_uploader'

module Core
  module Attendance
    class ContextNotification < ApplicationRecord
      self.table_name = 'extranet.attendance_context_notifications'

    end
  end
end
