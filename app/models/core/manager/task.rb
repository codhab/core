require_dependency 'core/application_record'

module Core
  module Manager
    class Task < ApplicationRecord
      self.table_name = 'extranet.manager_tasks'
      
      belongs_to :project
      belongs_to :sector,      class_name: ::Core::Person::Sector, foreign_key: :sector_id
      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id

      has_many   :problems,    class_name: ::Core::Manager::TaskProblem,    foreign_key: :task_id, dependent: :delete_all
      has_many   :comments,    class_name: ::Core::Manager::TaskComment,    foreign_key: :task_id, dependent: :delete_all
      has_many   :attachments, class_name: ::Core::Manager::TaskAttachment, foreign_key: :task_id, dependent: :delete_all
      has_many   :sub_tasks,   class_name: ::Core::Manager::SubTask,        foreign_key: :task_id, dependent: :delete_all
      
      scope :by_situation, -> (situation) { where(situation: situation)}
      
      enum priority:  ['baixa', 'normal', 'alta', 'urgênte']
      enum situation: ['aguardando', 'pendente', 'em_progresso', 'fechada']


      def allow_remove? current_user
        return false if !self.aguardando?

        (current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059' ||
        current_user.id == self.responsible_id ||
        current_user.sector_current_id == self.sector_id)
      end

      def allow_edit? current_user
        current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059'
      end

      def allow_update? current_user
        current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059' ||
        current_user.id == self.responsible_id ||
        current_user.sector_current_id == self.sector_id
      end

      def allow_update_days? current_user
        
        return false if self.fechada?


        (current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059' ||
        current_user.id == self.responsible_id ||
        current_user.sector_current_id == self.sector_id)
      end

      def allow_situation? current_user

        tasks         = self.project.tasks.order('manager_tasks.order ASC')

        return true  if tasks.count == 1

        previous_task = tasks.where('manager_tasks.order < ?', self.order).last  rescue nil
        next_task     = tasks.where('manager_tasks.order > ?', self.order).first rescue nil

        if !previous_task.nil? && !next_task.nil?
          if previous_task.fechada? && self.fechada? && !next_task.aguardando?
            return false
          end

          if !previous_task.fechada?
            return false
          end
        end

        # Primeira tarefa
        if previous_task.nil? && !next_task.nil?
          return false if !next_task.aguardando?
        end

        # Ultima tarefa
        if !previous_task.nil? && next_task.nil?
          return false if !previous_task.fechada?
        end

        (current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059' ||
        current_user.id == self.responsible_id ||
        current_user.sector_current_id == self.sector_id)

      end

      def allow_up_and_down? current_user
        current_user.id == self.project.responsible_id ||
        current_user.id == self.project.manager_id  ||
        current_user.administrator? ||
        current_user.code == '8508' ||
        current_user.code == '9059' ||
        current_user.id == self.responsible_id ||
        current_user.sector_current_id == self.sector_id
      end

      def up? 

        return false if !self.aguardando?
        
        tasks = self.project.tasks.order('manager_tasks.order ASC')
        previous_task = tasks.where('manager_tasks.order < ?', self.order).last rescue nil

        return false if !tasks.present?
        return false if tasks.count == 1
        return false if tasks.first.id == self.id
        return false if !previous_task.nil?  && !previous_task.aguardando?

        return true

      end

      def down?
        return false if !self.aguardando?
        
        tasks = self.project.tasks.order('manager_tasks.order ASC')

        return false if !tasks.present?
        return false if tasks.count == 1
        return false if tasks.last.id == self.id

        return true
      end

    end
  end
end
