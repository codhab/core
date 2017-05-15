require_dependency 'core/manager/task_problem'

module Core
  module Manager
    class TaskProblemForm < ::Core::Manager::TaskProblem

      validates :description, :recognition_date, presence: true
    end
  end
end