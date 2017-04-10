require_dependency 'core/attendance/ticket'
require_dependency 'core/notification_service'

module Core
  module Attendance
    class DocumentService

      # define :ticket_action_contexts
      # 1 => atualização dados básicos
      # 2 => atualização de dependentes 
      # 3 => atualização de renda 
      # 4 => atualização de dados de contato 
      
      # define :ticket_contexts table: `attendance_ticket_contexts`
      # 1 => atualização cadastral (recadastramento)
      # 2 => atualização cadastral (convocado)
      # 3 => atualização cadastral (habilitado)
      # 4 => atualização cadastral (regularização)
      # 5 => atualização cadastral (outro)
      
      attr_accessor :cadastre, :action, :ticket, :cadastre_mirror, :dependent_id

      def initialize(cadastre: nil, action: nil, ticket: nil, dependent_id: nil)
        @cadastre         = cadastre
        @action           = action
        @ticket           = ticket
        @dependent_id     = dependent_id
      end

      def documents
        Core::Attendance::TicketUploadCategory.all.order(:name)
      end

      def documents_required? document

      end

      def documents_required!

        @cadastre_mirror = @ticket.cadastre_mirror 
        
        case @action.context_id
        when 1 # (atualização dados básicos)
          cadastre_documents
        when 2 # (atualização de dependentes)
          dependent_documents
        when 3 # (atualização de renda)
          income_documents
        end
      end

      private

      def cadastre_documents
        if @ticket.context_id == 2

          @action.rg_documents.new(disable_destroy: true)
          @action.cpf_documents.new(disable_destroy: true)
          @action.born_documents.new(disable_destroy: true)
          @action.arrival_df_documents.new(disable_destroy: true)
          
          if @cadastre.special_condition_id == 2
            @action.special_condition_documents.new(disable_destroy: true)
          end

        else
          
          if @cadastre.rg != @cadastre_mirror.rg
            if !@action.rg_documents.any? {|k| k.persisted? }
              @action.rg_documents.new(disable_destroy: true)
            end
          end

          if @cadastre.born != @cadastre_mirror.born
            if !@action.born_documents.any? {|k| k.persisted? }
              @action.born_documents.new(disable_destroy: true)
            end
          end

          if (@cadastre.special_condition_id == 1 && @cadastre_mirror.special_condition_id == 2)
            if !@action.special_condition_documents.any? {|k| k.persisted? }
              @action.special_condition_documents.new(disable_destroy: true)
            end
          end

          if (@cadastre.arrival_df != @cadastre_mirror.arrival_df)
            if !@action.arrival_df_documents.any? {|k| k.persisted? }
              @action.arrival_df_documents.new(disable_destroy: true)
            end
          end

        end
      end

      def dependent_documents
        

        if !@dependent_id.nil?

          @dependent = Core::Candidate::DependentMirror.find(@dependent_id.to_i) rescue nil
          
          if !@ticket.context_id == 2

            if @dependent.age >= 14 && !@action.cpf_documents.find_by(target_id: @dependent.id).present?
              @action.cpf_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
            end

            if @dependent.age < 14
              @action.certificate_born_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
            end

            if @dependent.special_condition_id == 2
              @action.special_condition_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
            end
          else


            if @dependent.age < 14
              if !@action.certificate_born_documents.any? {|k| k.persisted? }
                @action.certificate_born_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
              end
            end

            if @dependent.special_condition_id == 2
              if !@action.special_condition_documents.any? {|k| k.persisted? }
                @action.special_condition_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
              end
            end

            if @dependent.dependent.present? && (@dependent.age >= 14 || (@dependent.cpf != @dependent.dependent.cpf))
              if !@action.cpf_documents.present?
                @action.cpf_documents.new(disable_destroy: true, target_id: @dependent.id, target_model: "Core::Candidate::DependentMirror")
              end
            end 
            
          end

        end

      end

      def income_documents

        if @dependent_id.nil?
          if (@ticket.cadastre.main_income.to_f != @ticket.cadastre_mirror.main_income.to_f) &&
            @ticket.cadastre_mirror.main_income.to_f > 0
            if !@action.income_documents.any? {|k| k.persisted? }
              @action.income_documents.new(disable_destroy: true)
            end
          end
        else
         
          dependent_mirror = Core::Candidate::DependentMirror.find(@dependent_id.to_i)

          if dependent_mirror.present?
            if dependent_mirror.income.to_f > 0
              if !@action.income_documents.any? {|k| k.persisted? }
                @action.income_documents.new(disable_destroy: true, target_id: @dependent_id.to_i, target_model: "Core::Candidate::DependentMirror")
              end
            end
          end

        end
        
        
      end

    end
  end
end