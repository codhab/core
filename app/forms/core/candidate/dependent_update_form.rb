require_dependency 'core/candidate/dependent'

module Core
  module Candidate
    class DependentUpdateForm < Core::Candidate::Dependent #:nodoc:
      attr_accessor :observation
      validates :observation, presence: true
    end
  end
end
