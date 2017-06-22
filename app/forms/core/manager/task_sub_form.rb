require_dependency 'core/manager/sub_task'

module Core
  module Manager
    class TaskSubForm < ::Core::Manager::SubTask

      validates :name, :due, presence: true
    end
  end
end