require_dependency 'core/manager/task_problem'

module Core
  module Manager
    class TaskProblemForm < ::Core::Manager::TaskProblem

      validates :description, :recognition_date, presence: true
      validates :resolution, presence: true, if: 'self.solved'

      validates :document, file_size: { less_than_or_equal_to: 25.megabytes }

      mount_uploader :document, Core::Manager::DocumentUploader
    end
  end
end