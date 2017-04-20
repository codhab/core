require_dependency 'core/application_record'

module Core
  module Attendance
    class Form < ApplicationRecord
      self.table_name = 'extranet.attendance_forms'

      has_many :form_fields
      has_many :form_values

      validates :name, :description, presence: true
      validates :name, uniqueness: true
    end
  end
end
