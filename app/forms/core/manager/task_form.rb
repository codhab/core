require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskForm < ::Core::Manager::Task

      validates :title, :description, :due, :priority, presence: true

      before_validation :set_date_solved

      private

      def set_date_solved
        self.solved_date = Date.current if self.solved
      end
    end
  end
end