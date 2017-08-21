require_dependency 'core/application_record'

module Core
  module SocialWork
    class ExecutorCompany < ApplicationRecord
      self.table_name = 'generic.social_work_executor_companies'

      belongs_to :company
    end
  end
end
