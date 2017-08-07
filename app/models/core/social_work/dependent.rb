require_dependency 'core/application_record'

module Core
  module SocialWork
    class Dependent < ApplicationRecord
      self.table_name = 'generic.social_work_dependents'
    end
  end
end
