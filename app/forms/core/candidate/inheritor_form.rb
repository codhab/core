require_dependency 'core/candidate/inheritor'

module Core
  module Candidate
    class InheritorForm < Core::Candidate::Inheritor #:nodoc:
      attr_accessor :observation
      validates :observation, presence: true
    end
  end
end
