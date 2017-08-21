require_dependency 'core/application_record'

module Core
  module SocialWork
    class Allotment < ApplicationRecord
      self.table_name = 'generic.social_work_allotments'

    end
  end
end
