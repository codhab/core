require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialAgreement < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_agreements'
    end
  end
end
