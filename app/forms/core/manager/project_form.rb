require_dependency 'core/manager/project'

module Core
  module Manager
    class ProjectForm < ::Core::Manager::Project

      validates :project_category_id,
                :responsible_id,
                :responsible_sector_id,
                :manager_id,
                :situation,
                :name, 
                :description, 
                :start,
                presence: true

      validates :name, uniqueness: true

      validate :responsible_is_valid?
      validate :manager_is_valid?
      validate :assessment_is_valid?, if: 'self.assessment.present?'

      after_save :set_template, if: 'self.template_id.present?', on: :create

      private

      def assessment_is_valid?
        document = ::Core::Protocol::Assessment.find_by_document_number(self.assessment) rescue nil
        
        if document.nil?
          errors.add(:assessment, "Nº de documento inválido ou não existe")
        end
      end

      def set_template
        
        template = ::Core::Manager::Template.where(status: true).find(self.template_id) rescue nil

        return false if template.nil?
        
        template.tasks.order(:order).each do |task|
          
          @new_task  = self.tasks.new
          @last_task = self.tasks.reject(&:new_record?).last 

          task.attributes.each do |key, value|
            
            unless %w(id created_at updated_at task_id priority).include? key
              @new_task.send("#{key}=", value) if @new_task.attributes.has_key?(key)
            end
            

          end

   
          if !@last_task.nil?
            
            if task.por_prioridade?
          
              if self.alta?
                @new_task.due = @last_task.due + 15
              end

              if self.média?
                @new_task.due = @last_task.due + 5
              end

              if self.baixa?
                @new_task.due = @last_task.due + 3
              end

            else
              @new_task.due = @last_task.due + task.due_days if @last_task.due.present?
            end

          else

            if task.por_prioridade?
              if self.alta?
                @new_task.due = self.start + 15
              end

              if self.média?
                @new_task.due = self.start + 5
              end

              if self.baixa?
                @new_task.due = self.start + 3
              end
            else
              @new_task.due = self.start + task.due_days
            end

          end

          @new_task.responsible_id = task.responsible_id
          @new_task.sector_id      = task.sector_id

          @new_task.save

        end

      end

      def responsible_is_valid?
        return false if self.responsible.nil?
        
        if self.responsible_sector_id != self.responsible.sector_current_id
          errors.add(:responsible_id, "Servidor não está lotado no setor responsável informado")
        end
      end

      def manager_is_valid?
        return false if self.manager.nil?

        if self.responsible_sector_id != self.manager.sector_current_id
          errors.add(:manager_id, "Servidor não está lotado no setor responsável informado")
        end
      end

    end
  end
end