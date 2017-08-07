require_dependency 'core/application_record'

module Core
  module SocialWork
    class Company < ApplicationRecord
      self.table_name = 'generic.social_work_companies'
    end
  end
end
