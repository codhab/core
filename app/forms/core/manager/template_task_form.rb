module Core
  module Manager
    class TemplateTaskForm < ::Core::Manager::TemplateTask
      validates :title, :description, presence: true
      validates :due_days, numericality: true, presence: true
      validate  :due_max_days
      validate  :due_days_not_equal_zero

      before_validation :set_order, on: :create
      before_destroy    :reset_order

      def order_up
        return false if self.order == 0

        current_order = self.order
        next_order    = self.order - 1

        current_task = self
        old_task     = self.template.tasks.find_by_order(next_order) rescue nil


        return false if old_task.nil?

        current_task.update(order: next_order)
        old_task.update(order: current_order)
      end

      def order_down
        return false if self.order == self.template.tasks.count
        
        current_order = self.order
        next_order    = self.order + 1

        current_task = self
        old_task     = self.template.tasks.find_by_order(next_order) rescue nil

        return false if old_task.nil?
        
        current_task.update(order: next_order)
        old_task.update(order: current_order)
      end

      private 

      def due_days_not_equal_zero
        if self.due_days.to_i <= 0
          errors.add(:due_days, "Valor não pode menor ou igual a 0")
        end
      end

      def due_max_days
        if self.due_days > 15
          errors.add(:due_days, "O prazo em dias não pode passar de 15 dias")
        end
      end

      def set_order
        last_task = self.template.tasks.order(:order).last

        if last_task.nil?
          self.order = 0
        else
          self.order = last_task.order + 1
        end

      end


      def reset_order
        tasks = self.template.tasks.where.not(id: self.id)
        tasks.order('"order" ASC').each_with_index do |task, index|
          task.update(order: index)
        end
      end

    end
  end
end