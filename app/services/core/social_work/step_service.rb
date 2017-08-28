module Core
  module SocialWork
    class StepService

      def create_step! step, project, description
        @step = Core::SocialWork::StepProject.new(
          step_id: step,
          candidate_project_id: project,
          description: description
        )
        @step.save
      end

    end
  end
end
