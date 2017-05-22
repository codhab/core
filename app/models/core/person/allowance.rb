require_dependency 'core/application_record'

module Core
  module Person
    class Allowance < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.person_allowances'

      belongs_to :employee, class_name: ::Core::Person::Staff, foreign_key: 'employee_id'
      belongs_to :staff,    class_name: ::Core::Person::Staff
    end
  end
end
