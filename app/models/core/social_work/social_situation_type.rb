require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialSituationType < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_situation_types'
    end
  end
end
