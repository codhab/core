require_dependency 'core/application_record'

module Core
  module SocialWork
    class AttendanceStation < ApplicationRecord
      self.table_name = 'generic.social_work_attendance_stations'
    end
  end
end
