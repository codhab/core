require_dependency 'core/application_record'

module Core
  module SocialWork
    class CompanyUser < ApplicationRecord
      self.table_name = 'generic.social_work_company_users'
    end
  end
end
