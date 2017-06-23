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

       # return false if context_id.to_i == 0
       
        #refatorar, forçando somente recadastramento ou context_id igual ao já criado
        @ticket = @cadastre.tickets.find_by(context_id: 1) rescue nil
        
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

          if @ticket.context_id == 1
            title = "Atualização Cadastral Nº #{@ticket.presenter.protocol} foi iniciada."
            text  = "Sua atualização cadastral foi inciada. Atualize ou confirme os 4 passos existentes em seu cadastro, verifique os termos de aceite e finalize o procedimento."
          else
            title = "Atualização de dados Nº #{@ticket.presenter.protocol} foi iniciada."
            text  = "Sua atualização de dados foi inciada. Atualize ou confirme os 4 passos existentes em seu cadastro, verifique os termos de aceite e finalize o procedimento."
          end

          service = Core::NotificationService.new
          service.create({
                          cadastre_id: @ticket.cadastre_id,
                          category_id: 1,
                          title: title,
                          content: text.html_safe,
                          target_model: @ticket.class,
                          target: @ticket.id,
                          push: true,
                          email: true
                        })
        end

      end

      def create_or_find_action action_id
        return false if @ticket.situation_id != 1
        @action = @ticket.actions.find_by(context_id: action_id) rescue nil

        if @action.nil?
          @action = @ticket.actions.new.tap do |action|
            action.context_id     = action_id
            action.situation_id   = set_context_situation
            action.started_at     = Time.now
          end

          @action.save
        end
      end

      def open_action
        return false if @ticket.nil? || !@ticket.actions.present? || @action.nil?
        @action.update(situation_id: 2)
      end

      def confirm_action
        return false if @ticket.nil? || !@ticket.actions.present? || @action.nil?
        @action.update(situation_id: 4)
      end


      def close_action
        return false if @ticket.nil? || !@ticket.actions.present? || @action.nil?
        @action.update(situation_id: 3)
      end

      def close_ticket

        return false if @ticket.nil?
        return false if @ticket.actions.where(situation_id: 1).present?

          # 1 => atualização cadastral (recadastramento)
        if @ticket.context_id == 1

          if @ticket.actions.where(situation_id: 3).present?


            if important_data_updated?
              @ticket.update(situation_id: 2, active: true)
            else
              @ticket.update(situation_id: 7, active: true)
              scoring_cadastre
            end

          else

            @ticket.update(situation_id: 7, active: true)
            scoring_cadastre
          end

        elsif @ticket.context_id == 3

          if important_data_updated?
            @ticket.update(situation_id: 2, active: true)
          else
            @ticket.update(situation_id: 7, active: false)

            scoring_cadastre
          end

        elsif @ticket.context_id == 5
          # 7 => finalizado pelo candidato
          @ticket.update(situation_id: 7, active: false)

          scoring_cadastre
        else

          if important_data_updated?
            @ticket.update(situation_id: 2, active: true)
          else
            @ticket.update(situation_id: 7, active: false)
          end

        end

        if @ticket.context_id == 1
          title   = "Atualização Cadastral Nº #{@ticket.presenter.protocol} foi finalizada por você"
          message = "Sua atualização cadastral foi finalizada. Caso tenha informado novos dados que necessitem ser validados, faz-se necessário aguardar o retorno do atendimento da CODHAB. Você receberá notificações informando o andamento da situação da sua atualização."
        else
          title   = "Atualização Cadastral Nº #{@ticket.presenter.protocol} foi finalizada por você"
          message = "Sua atualização de dados foi finalizada. Caso tenha informado novos dados que necessitem ser validados, faz-se necessário aguardar o retorno do atendimento da CODHAB. Você receberá notificações informando o andamento da situação da sua atualização."
        end


        notification = Core::NotificationService.new

        notification.create({
          cadastre_id: @ticket.cadastre_id,
          category_id: 1,
          content: message,
          title: "Atualização Cadastral Nº #{@ticket.presenter.protocol} foi finalizada por você",
          push: true,
          email: true
        })

      end

      def scoring_cadastre
        if @ticket.context_id != 4
          @cadastre_mirror = @ticket.cadastre_mirror
          @score = Core::Candidate::ScoreService.new(cadastre_mirror_id: @cadastre_mirror)
          @scores = @score.scoring_cadastre!

          @pontuation = Core::Candidate::Pontuation.new(
            cadastre_id: @cadastre_mirror.cadastre_id,
            cadastre_mirror_id: @cadastre_mirror.id,
            bsb: @scores[:timebsb_score],
            dependent: @scores[:dependent_score],
            timelist: @scores[:timelist_score],
            special_condition: @scores[:special_dependent_score],
            income: @scores[:income_score],
            total: @scores[:total],
            program_id: @cadastre_mirror.program_id
          )
          @pontuation.save

          rewrite_to_cadastre!
          rewrite_to_dependents!
        end
      end

      private

      def important_data_updated?

        @index = 0
        @cadastre = @ticket.cadastre
        @mirror   = @ticket.cadastre_mirror

        @cadastre.attributes.keys.each do |key|
          if %w(name rg cpf special_condition_id born arrival_df main_income).include? key
            @index += 1 if @cadastre[key] != @mirror[key]
          end
        end

        @cadastre.dependents.each do |dependent|
          @dep_mirror = @mirror.dependent_mirrors.find_by_dependent_id(dependent.id) rescue nil


          if @dep_mirror.nil?
            @index += 1
          else
            dependent.attributes.keys.each do |dependent_key|
              if %w(name rg cpf special_condition_id born income).include? dependent_key
                @index += 1 if dependent[dependent_key] != @dep_mirror[dependent_key]
              end
            end
          end

        end


        (@index == 0) ? false : true

      end

      def set_context_situation
        @ticket.context.confirmation_required ? 1 : 2
      end


      def send_notification_by_action action = nil
        return false if action.nil?

        content = Core::Attendance::ContextNotification.find_by(action: action) rescue nil

        return false if content.nil?

        notification = Core::NotificationService.new(cadastre: @cadastre)
        notification.create(title: content.title, message: content.message, push: true, email: true)
      end


      def rewrite_to_cadastre!
        return false if @ticket.cadastre.nil? || @ticket.cadastre_mirror.nil?

        @ticket.cadastre_mirror.attributes.each do |key, value|
          unless %w(id created_at updated_at).include? key
            @ticket.cadastre[key] = value if @ticket.cadastre.attributes.has_key?(key)
          end
        end
        @ticket.cadastre.save
      end

      def rewrite_to_dependents!
        @dependents = @ticket.cadastre_mirror.dependent_mirrors

        @ticket.cadastre.dependents.delete_all

        @dependents.each do |dependent|
          @new_dependent = @ticket.cadastre.dependents.new
          dependent.attributes.each do |key, value|
            unless %w(id created_at cadastre_id updated_at).include? key
              @new_dependent[key] = value if @new_dependent.attributes.has_key?(key)
            end
          end
          @new_dependent.save
        end
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
          @new_dependent = @cadastre_mirror.dependent_mirrors.new(dependent_id: dependent.id)

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
