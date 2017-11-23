require_dependency 'core/application_record'

module Core
  module Person
    class Job < ApplicationRecord
      self.table_name = 'extranet.person_jobs'
    end
  end
end
