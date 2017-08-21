require_dependency 'core/application_record'

module Core
  module SocialWork
    class AttendanceStation < ApplicationRecord
      self.table_name = 'generic.social_work_attendance_stations'
      belongs_to :city,              required: false, class_name: ::Core::Address::City
      has_many :candidate_schedules
    end
  end
end
