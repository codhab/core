require_dependency 'core/application_record'

module Core
  module SocialWork
    class AttendanceStation < ApplicationRecord
      self.table_name = 'generic.social_work_attendance_stations'
      belongs_to :technical_assistance_station
      has_many :candidate_schedules
    end
  end
end
