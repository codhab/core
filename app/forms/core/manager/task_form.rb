require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskForm < ::Core::Manager::Task

      # priority:  ['baixa', 'normal', 'alta', 'urgênte']
      # situation: ['aguardando', 'pendente', 'em progresso', 'fechada']

      attr_accessor :start, :reprocess
      
      validates :title, :description, :priority, :due_days, presence: true

      before_validation :set_date_solved

      before_save   :set_dinamic_due, if: 'self.fechada?'

      after_commit :set_situation_for_next_task
      after_save   :set_due_for_next_tasks
      validate     :due_days_not_equal_zero

      private

      def due_days_not_equal_zero
        if self.due_days.to_i <= 0
          errors.add(:due_days, "Valor não pode menor ou igual a 0")
        end
      end

      def set_dinamic_due
        self.due = self.solved_date
      end

      def set_date_solved
        self.solved_date = Date.current if self.fechada?
      end

      def set_situation_for_next_task
        return false if !self.fechada?
        
        tasks = self.project.tasks.order('original_due ASC').map(&:id)
        current_task_index = tasks.find_index(self.id)
        next_task_index    = tasks[current_task_index + 1]

        next_task = self.project.tasks.find(next_task_index)
        
        if !next_task.nil?
          next_task.update(situation: 1) 
          staffs = Core::Person::Staff.where(sector_current_id: next_task.sector_id, status: true)
        
          begin
            Core::Manager::NotificationService.send_notification(staffs, self, next_task)
          rescue Exception => e 
            puts e
          end
        end
      end

      def set_due_for_next_tasks
        all_tasks = self.project.tasks.order('due ASC')
        tasks = self.project.tasks.where("original_due >= ?", self.original_due).order('original_due ASC')
         
        
        if tasks.present?
          @last_task = nil

          tasks.each_with_index do |task, index|

            if index == 0 && all_tasks.first.id == task.id
              task.due  = self.due_days.business_day.from_now(self.due)
              task.save
            elsif @last_task.nil?
              task.due  = task.due_days.business_day.from_now(self.due)
              task.save
            else
              task.due  = task.due_days.business_day.from_now(@last_task.due)
              task.save
            end

            @last_task = task
          end
        else
          task = self.project.tasks.find(self.id)
          task.due = task.due_days.business_day.from_now(task.project.start) + 1.day
          task.save
        end

      end

    end
  end
end