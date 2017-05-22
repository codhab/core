require_dependency 'core/application_record'

module Core
  module Person
    class Vocation < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.person_vocations'

      belongs_to :staff, class_name: ::Core::Person::Staff
    end
  end
end
