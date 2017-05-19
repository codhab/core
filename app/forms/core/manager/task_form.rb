require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskForm < ::Core::Manager::Task

      # priority:  ['baixa', 'normal', 'alta', 'urgênte']
      # situation: ['aguardando', 'pendente', 'em progresso', 'fechada']

      attr_accessor :start, :reprocess
      
      validates :title, :description, :priority, presence: true

      before_validation :set_date_solved

      after_commit :set_situation_for_next_task
      after_commit :set_due_for_next_tasks

      private

      def set_date_solved
        self.solved_date = Date.current if self.fechada?
      end

      def set_situation_for_next_task
        return false if !self.fechada?
        
        next_task = self.project.tasks.where('due > ? and situation = 0', self.due ).order('due ASC').first rescue nil
        self.project.tasks.where(due: next_task.due).update(situation: 1) if !next_task.nil?
        
      end

      def set_due_for_next_tasks
        tasks = self.project.tasks.where('due > ? ', self.due).order('due ASC')

        @last_task = nil

        tasks.each_with_index do |task, index|
          
          if index == 0
            task.due  = self.due_days.business_day.from_now(self.due)
            task.save
          else
            task.due  = @last_task.due_days.business_day.from_now(@last_task.due)
            task.save
          end

          @last_task = task
        end

      end

    end
  end
end