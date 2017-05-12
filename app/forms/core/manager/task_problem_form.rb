require_dependency 'core/manager/task_problem'

module Core
  module Manager
    class TaskProblemForm < ::Core::Manager::TaskProblem

      validates :description, :recognition_date, presence: true
      validates :resolution, presence: true, if: 'self.solved'
    end
  end
end