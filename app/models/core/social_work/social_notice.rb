require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialNotice < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_notices'
    end
  end
end
