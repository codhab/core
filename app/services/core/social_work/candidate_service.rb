module Core
  module SocialWork
    class CandidateService

      def initialize(candidate)
        @candidate = candidate
      end

      def create_project!
        @project = Core::SocialWork::CandidateProject.new(
          address: @candidate.address,
          complement_address: @candidate.complement_address,
          candidate_id: @candidate.id,
          city_id: @candidate.city_id
        )
        @project.save
      end

    end
  end
end
