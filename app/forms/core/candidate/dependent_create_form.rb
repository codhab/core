require_dependency 'core/candidate/dependent'

module Core
  module Candidate
    class DependentCreateForm < Core::Candidate::Dependent #:nodoc:
      attr_accessor :observation, :creator_id

      validates :name, :born, :place_birth, presence: true
      validates :civil_state, :special_condition, :kinship, presence: true

      validates :observation, presence: true

      after_create :set_observation

      private

      def set_observation
        Core::Candidate::CadastreObservation.new(
          cadastre_id: id,
          observation: self.observation,
          staff_id: self.creator_id
        ).save
      end
    end
  end
end
