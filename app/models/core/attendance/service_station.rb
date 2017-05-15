require_dependency 'core/application_record'

module Core
  module Attendance
    class ServiceStation < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.attendance_service_stations'

      belongs_to :city, class_name: Core::Address::City
      has_many :attendants, dependent: :destroy
      validates :name, :city, presence: true
    end
  end
end
