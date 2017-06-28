require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskForm < ::Core::Manager::Task
     
      validates :title, :description, :priority, :due_days, presence: true
      validate  :due_days_not_equal_zero


      # POLICIES


      def up_order_task

        current_task  = self
        tasks         = self.project.tasks.order('manager_tasks.order ASC')
        next_task     = tasks.where('manager_tasks.order < ?', self.order).last rescue nil
        first_task    = tasks.where(situation: 0).first rescue nil
        first_task    = Core::Manager::TaskForm.find(first_task.id) rescue nil
        

        return true if next_task.nil?
        
        current_order = self.order
        next_order    = next_task.order 

        next_task.order    = current_order
        next_task.save 

        current_task.order = next_order
        current_task.save 

        if !first_task.nil?
          first_task.recalculate_deadlines
        end

      end

      def down_order_task

        current_task  = self
        tasks         = self.project.tasks.order('manager_tasks.order ASC')
        next_task     = tasks.where('manager_tasks.order > ?', self.order).first rescue nil
        first_task    = tasks.where(situation: 0).first rescue nil
        first_task    = Core::Manager::TaskForm.find(first_task.id) rescue nil

        return true if next_task.nil?
        
        current_order = self.order
        next_order    = next_task.order 

        next_task.order    = current_order
        next_task.save 

        current_task.order = next_order
        current_task.save 
        
        if !first_task.nil?
          first_task.recalculate_deadlines
        end

      end

      def set_order
        tasks = self.project.tasks.order('manager_tasks.order DESC')
        
        if tasks.present? && tasks.count > 1

          new_order  = tasks.second.order + 1
          self.order = new_order
          self.save

        else
          self.order = 0
          self.save        
        end
      end


      def set_due_task

        tasks   = self.project.tasks.order('manager_tasks.order ASC')
        previous_task = tasks.where('manager_tasks.order < ?', self.order).last rescue nil

        if !previous_task.nil?
          self.due = self.due_days.business_day.from_now(previous_task.due)
          self.save
        else
          self.due = self.due_days.business_day.from_now(self.project.start)
          self.save 
        end

      end

      def recalculate_deadlines
        tasks = self.project.tasks.order('manager_tasks.order ASC')
        scoped_tasks  = tasks.where('manager_tasks.order >= ?', self.order)
        previous_task = tasks.where('manager_tasks.order < ?', self.order).last rescue nil
        
        if scoped_tasks.present?
       
          scoped_tasks.each_with_index do |task, index|

            if index == 0
              if previous_task.nil?
                task.due  = task.due_days.business_day.from_now(task.project.start)
                task.save
              else
                task.due  = task.due_days.business_day.from_now(previous_task.due)
                task.save
              end
            else
              task.due = task.due_days.business_day.from_now(@last_task.due)
            end

            task.save

            @last_task = task
          end

        end

      end


      def update_next_task

        return false if !self.fechada?

        tasks = self.project.tasks.order('manager_tasks.order ASC')

        if tasks.present?

          next_task = tasks.where('manager_tasks.order > ?', self.order).first rescue nil

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

        self.solved_date = Date.current 
        self.due         = Date.current

        self.save

      end


      def destroy_and_recalculate_deadlines
        tasks         = self.project.tasks.order('manager_tasks.order ASC')
        first_task    = tasks.where(situation: 0).first rescue nil
        first_task    = Core::Manager::TaskForm.find(first_task.id) rescue nil

        if !first_task.nil?
          first_task.recalculate_deadlines
        end
      end

      private


      def due_days_not_equal_zero
        if self.due_days.to_i <= 0
          errors.add(:due_days, "Valor não pode menor ou igual a 0")
        end
      end

    end
  end
end