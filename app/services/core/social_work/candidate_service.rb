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

        @step = Core::SocialWork::StepProject.new(
          step_id: 2,
          candidate_project_id: @project.id,
          description: 'Andamento inicial.'
        )
        @step.save
      end

    end
  end
end
