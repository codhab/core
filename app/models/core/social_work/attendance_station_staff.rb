require_dependency 'core/application_record'

module Core
  module SocialWork
    class AttendanceStationStaff < ApplicationRecord
      self.table_name = 'generic.social_work_attendance_station_staffs'
    end
  end
end
