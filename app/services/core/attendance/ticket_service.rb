require_dependency 'core/attendance/ticket'
require_dependency 'core/notification_service'

module Core
  module Attendance
    class TicketService
      
      # Scope :attendance_tickets
      #
      # define :ticket_situations, table: `attendance_ticket_situations`
      # 1 => pendente com candidato
      # 2 => pendente com atendente
      # 3 => pendente com supervisor
      # 4 => cancelado pelo candidato
      # 5 => deferido
      # 6 => indeferido
      # 7 => finalizado pelo candidato
      
      # define :ticket_contexts table: `attendance_ticket_contexts`
      # 1 => atualização cadastral (recadastramento)
      # 2 => atualização cadastral (convocado)
      # 3 => atualização cadastral (habilitado)
      # 4 => atualização cadastral (regularização)
      # 5 => atualização cadastral (outro)

      # Scope :attendance_ticket_actions
      #
      # define :ticket_action_contexts
      # 1 => atualização dados básicos
      # 2 => atualização de dependentes 
      # 3 => atualização de renda 
      # 4 => atualização de dados de contato 

      # define :ticket_action_situations
      # 1 => em processo de atualização
      # 2 => atualizado
      # 3 => confirmado

      attr_accessor :cadastre, :ticket, :cadastre_mirror, :action

      def initialize(cadastre: nil, ticket: nil, cadastre_mirror: nil, action: nil)
        @cadastre         = cadastre
        @ticket           = ticket
        @cadastre_mirror  = cadastre_mirror
        @action           = action
      end

      def create_or_find context_id
        @ticket = @cadastre.tickets.find_by(active: true) rescue nil

        if @ticket.nil?
          clone_cadastre_to_make_mirrors!

          @ticket = @cadastre.tickets.new.tap do |ticket|
            ticket.cadastre_mirror_id   = @cadastre_mirror.id
            ticket.started_at           = Time.now
            ticket.situation_id         = 1
            ticket.context_id           = context_id
            ticket.active               = true
          end

          @ticket.save

        end

      end

      def create_or_find_action action_id
        @action = @ticket.actions.find_by(context_id: action_id) rescue nil

        if @action.nil?
          
          @action = @ticket.actions.new.tap do |action|
            action.context_id     = action_id
            action.situation_id   = 1
            action.started_at     = Time.now
          end

          @action.save

        end
      end

      def confirm

        return false if @ticket.nil? || !@ticket.ticket_actions.present? || @action.nil?

        @action.update(situation_id: 2)

      end

      def cancel

        return false if @ticket.nil?

        @action.update(situation_id: 4)

      end

      def close
        return false if @ticket.nil?
        return false if @ticket.ticket_actions.where(situation_id: 1).present?
        
        # Regra #1
        # Atendimentos que contém em suas acões a situação `atualizado`
        # colocar os mesmo para análise do atendente  esta clásula deve
        # ignorada quando a ação for do tipo `atualização de dados de contato`
        #
        # SE (situation_id = 2) EM ticket_actions.where.not(context_id: 4) `atualização de contatos`
        # => ATTRIBUIR ticket_situation_id = 2 `pendente com atendente`        
        # SE NÃO
        # => ATTRIBUIR ticket_situation_id = 7 `finalizado pelo candidato`        


        @actions = @ticket.ticket_actions.where.not(context_id: 4).where(situation_id: 2)

        #pendente com atendente : finalizado pelo candidato
        situation_id = @actions.present? ? 2 : 7 

        @ticket.update(situation_id: situation_id)
        
      end

      private
      
      def set_ticket_context
        # Verifica qual tipo de contexto pode ser criado para o candidato
        # 1 - Se for habilitado e não tiver atendimento de recadastramento 
        # e program_id = [1,2] 
        # => recadastramento
        #
        # 2 - Se tiver atendimento de recastramento finalizado e 
        # for habilitado e program_id = [1,2] 
        # =>  atualização cadastral (habilitado)  
        # 
        # 3 - Se não for convocado e programa_id = [1,2]
        # => atualização cadastral (convocado) 
        #
        # 4 - Se for program_id = 3
        # => atualiazação cadastral (regularização)
        #
        # 5 - Se não se adequar em nenhuma das regras
        # => atualização cadastral (outro)

        @cadastre = Core::Candidate::CadastrePresenter.new(@cadastre)

        # ele é RII ou RIE
        if [1, 2].include?(@cadastre.program_id)
          # ele é habilitado?
          if @cadastre.current_situation_id == 4 
            # ele fez o recadastramento?
            if @cadastre.tickets.where(context_id: 1).where.not(situation_id: 1).present?
              #retorna contexto atualização cadastral (habilitado)
              return 3 
            else
              #retorna contexto atualização cadastral (recadastramento)
              return 1 
            end
          elsif @cadastre.current_situation_id == 3
            if !@cadastre.tickets.where(context_id: 2).where.not(situation_id: [5,6,7]).present? 
              #retorna contexto atualização cadastral (convocado)
              return 2 
            else
              #retorna false, pois convocado só poderá fazer um atendimento.
              return false 
            end
          else
            #retorna contexto atualização cadastral (outro)
            return 5 
          end
        # ele é de regularização
        elsif @cadastre.program_id == 3
          # não possui regras
          #retorna contexto atualização cadastral (regularização)
          return 4 
        # não entra em nenhuma regra
        else
          #retorna contexto atualização cadastral (outro)
          return 5
        end 
      end

      def send_notification_by_action action = nil
        return false if action.nil?

        content = Core::Attendance::ContextNotification.find_by(action: action) rescue nil
        
        return false if content.nil?

        notification = Core::NotificationService.new(cadastre: @cadastre)
        notification.create(title: content.title, message: content.message, push: true, email: true)
      end 

      def clone_cadastre_to_make_mirrors!
        return false if @cadastre.nil?

        @cadastre_mirror = @cadastre.cadastre_mirrors.new

        @cadastre.attributes.each do |key, value|
          unless %w(id created_at updated_at).include? key
            @cadastre_mirror[key] = value if @cadastre_mirror.attributes.has_key?(key)
          end
        end

        @cadastre_mirror.save!
      
        @dependents = @cadastre.dependents

        @dependents.each do |dependent|
          @new_dependent = @cadastre_mirror.dependent_mirrors.new
          
          dependent.attributes.each do |key, value|
            unless %w(id created_at updated_at).include? key
              @new_dependent[key] = value if @new_dependent.attributes.has_key?(key)
            end
          end

          @new_dependent.save
      
        end
      end

    end
  end
end
