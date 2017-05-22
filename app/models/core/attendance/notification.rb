module Core
  module Attendance
    class Notification < ActiveRecord::Base
      self.table_name = 'extranet.attendance_notifications'

      belongs_to :cadastre, class_name: ::Core::Candidate::Cadastre

      scope :unread, -> { where(read: false)}
    end
  end
end
