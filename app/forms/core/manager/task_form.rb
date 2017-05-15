require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskForm < ::Core::Manager::Task

      validates :title, :description, :due, :priority, presence: true
    end
  end
end