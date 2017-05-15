require_dependency 'core/application_record'

module Core
  module Attendance
    class FormField < ApplicationRecord
      self.table_name = 'extranet.attendance_form_fields'
      belongs_to :form

      default_scope  -> { order('order_item ASC')}
      
      scope :allows, -> { where(allow: true)}

      enum field_type: ['_string', '_text', '_integer', '_file', '_select']
    

      validates :name, :label, :field_type, presence: true
      validates_uniqueness_of :name, scope: :form_id


    end
  end
end
