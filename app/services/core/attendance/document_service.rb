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

      def initialize(cadastre: nil, action: nil, ticket: nil, dependent_mirror: nil, dependent_all: false)
        @cadastre         = cadastre
        @action           = action
        @ticket           = ticket
        @dependent_mirror = dependent_mirror
        @dependent_all    = dependent_all
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

        if @dependent_all

          @cadastre_mirror.dependent_mirrors.each do |dependent|
            if dependent.age >= 14 && !@action.cpf_documents.find_by(target_id: dependent.id).present?
              @action.cpf_documents.new(disable_destroy: true, target_id: dependent.id, target_model: "Core::Candidate::DependentMirror")
            end

            if dependent.age < 14
              @action.certificate_born_documents.new(disable_destroy: true, target_id: dependent.id, target_model: "Core::Candidate::DependentMirror")
            end

            if dependent.special_condition_id == 2
              @action.special_condition_documents.new(disable_destroy: true, target_id: dependent.id, target_model: "Core::Candidate::DependentMirror")
            end
          end

        elsif @ticket.context_id == 2
          
          @action.certificate_born_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
          
          if @dependent_mirror.age >= 14
            @action.cpf_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
          end

          if @dependent_mirror.special_condition_id == 2
            @action.special_condition_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
          end

        else

          if @dependent_mirror.present?
            dependent = @cadastre.dependents.find_by_name(@dependent_mirror.name) rescue nil

            if dependent.nil? || @dependent_mirror.rg != dependent.name
              @action.rg_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
            end

            if dependent.nil? || @dependent_mirror.cpf != dependent.cpf 
              @action.cpf_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
            end

            if dependent.nil? || @dependent_mirror.special_condition_id == 2 &&
              (@dependent_mirror.special_condition_id != dependent.special_condition_id)
              @action.special_condition_documents.new(disable_destroy: true, target_id: @dependent_mirror.id, target_model: "Core::Candidate::DependentMirror")
            end
          end

        end

      end

      def income_documents


        if @ticket.context_id == 2
          
          @action.income_documents.new(disable_destroy: true, target_id: @ticket.cadastre_mirror_id, target_model: "Core::Candidate::CadastreMirror")

          @cadastre_mirror.dependent_mirrors.each do |mirror|
            if mirror.income.to_f > 0
              @action.income_documents.new(disable_destroy: true, target_id: mirror.id, target_model: "Core::Candidate::DependentMirror")
            end
          end

        else

          if @cadastre.main_income.to_f != @cadastre_mirror.main_income.to_f
            @action.income_documents.new(disable_destroy: true)
          end

          @cadastre_mirror.dependent_mirrors.each do |mirror|
            dependent = @cadastre.dependents.find_by_name(mirror.name) rescue nil
            
            if dependent.present?
              if (dependent.income != mirror.income) && mirror.income.to_i > 0
                @action.income_documents.new(disable_destroy: true, target_id: mirror.id, target_model: "Core::Candidate::DependentMirror")
              end
            end
          end

        end




      end

    end
  end
end