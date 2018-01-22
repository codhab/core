require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialProject < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_projects'
      belongs_to :company, class_name: 'Core::SocialWork::Company'
      belongs_to :station, class_name: 'Core::TechnicalAssistance::Station'

      has_many :candidates, class_name: 'Core::SocialWork::SocialCandidate', foreign_key: :project_id
    end
  end
end
