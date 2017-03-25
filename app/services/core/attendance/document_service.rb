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
      
      attr_accessor :cadastre, :action, :ticket, :cadastre_mirror

      def initialize(cadastre: nil, action: nil, ticket: nil)
        @cadastre = cadastre
        @action   = action
        @ticket   = ticket
      end

      def documents
        return Core::Attendance::TicketUploadCategory.all.order(:name)
      end

      def documents_required? document
      end

      def documents_required!
        @cadastre_mirror = @ticket.cadastre_mirror 
        
        case @action.context_id
        when 1 # (atualização dados básicos)
          #se atualização cadastral (convocado) => pedir todos os documentos
          if @ticket.context_id == 2
          
          else
          
          end

        when 2 # (atualização de dependentes)
        
          #se atualização cadastral (convocado) => pedir todos os documentos
          if @ticket.context_id == 2
          
          else
          
          end

        when 3 # (atualização de renda)
          income_documents
        when 4 # (atualização de dados de contato)
        
          #se atualização cadastral (convocado) => pedir todos os documentos
          if @ticket.context_id == 2
          
          else
          
          end

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
            @action.rg_documents.new(disable_destroy: true)
          end

          if @cadastre.born != @cadastre_mirror.born
            @action.born_documents.new(disable_destroy: true)
          end

          if (@cadastre.special_condition_id == 1 && @cadastre_mirror.special_condition_id == 2)
            @action.special_condition_documents.new(disable_destroy: true)
          end

        end
      end

      def dependent_documents
      end

      def income_documents


        if @ticket.context_id == 2
          
          @action.income_documents.new(disable_destroy: true)

          @cadastre_mirror.dependent_mirrors.each do |mirror|
            @action.income_documents.new(disable_destroy: true)
          end

        else

          if @cadastre.main_income.to_f != @cadastre_mirror.main_income.to_f
            @action.income_documents.new(disable_destroy: true)
          end

          
          @cadastre_mirror.dependent_mirrors.each do |mirror|
            dependent = @cadastre.dependents.find_by_name(mirror.name) rescue nil
            
            if dependent.present?
              if dependent.income != mirror.income
                @action.income_documents.new(disable_destroy: true)
              end
            else
              @action.income_documents.new(disable_destroy: true)
            end
          end

        end




      end

    end
  end
end