require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialCandidateSituation < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_candidate_situations'

      belongs_to :candidate, class_name: 'Core::SocialWork::SocialCandidate'
      belongs_to :situation, class_name: 'Core::SocialWork::SocialSituationType'

      scope :delivered, ->{
        where(id: Core::SocialWork::SocialCandidateSituation
                  .select('max(id)').group(:candidate_id), situation_id: 3)
      }

      scope :countable, ->{ joins(:situation).where('social_situation_types.countable is true') }

    end
  end
end
