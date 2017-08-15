require_dependency 'core/application_record'

module Core
  module SocialWork
    class Pension < ApplicationRecord
      self.table_name = 'generic.social_work_pensions'
    end
  end
end
