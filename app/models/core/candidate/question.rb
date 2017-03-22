require_dependency 'core/application_record'
require_dependency 'core/attendance/ticket'
require_dependency 'core/attendance/subject'
require_dependency 'core/person/staff'

module Core
  module Candidate
    class Question <  ApplicationRecord
      self.table_name = 'extranet.candidate_questions'

      belongs_to :ticket,   required: false, class_name: ::Core::Attendance::Ticket
      belongs_to :subject,  required: false, class_name: ::Core::Attendance::Subject
      belongs_to :staff,    required: false, class_name: ::Core::Person::Staff

    end
  end
end
