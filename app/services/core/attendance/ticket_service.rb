require_dependency 'core/attendance/ticket'
require_dependency 'core/notification_service'

module Core
  module Attendance
    class TicketService

      attr_accessor(:cadastre_mirror,
                    :cadastre,
                    :cadastre_id,
                    :ticket,
                    :context_id,
                    :view,
                    :notification_service)

      def cadastre=(object)
        @cadastre = CoreAttendance::Candidate::Cadastre.find(object.id)
      end

      def create(status_id: 1, notification: true, push: true)

        return false if @cadastre.nil? || @context_id.nil?
        return false if @cadastre.tickets.where(ticket_context_id: @context_id, status: true).present?

        clone_cadastre_to_make_mirror!

        @ticket = Ticket.new({
          ticket_context_id: @context_id,
          ticket_status_id: status_id, 
          cadastre_id: @cadastre.id,
          cadastre_mirror_id: @cadastre_mirror.id
        })

        @ticket.save

        if notification
          @notification_service = NotificationService.new(cadastre: @cadastre)
          @notification_service.create_notification do |service| 
            service.category_id = 2
            service.title       = title.html_safe
            service.content     = message.html_safe
            service.link        = ''
            service.push        = true
          end
        end
        
      end

      def update(status_id: nil, notification: true, push: true)
        return false if status_id.nil? || @cadastre.nil? || @ticket.nil?

        title     = "Situação do seu atendimento de nº #{@ticket.id} foi atualizado."
        message   = render_message 'update_ticket'


        @ticket.update(ticket_status_id: status_id)

        if notification
          @service = NotificationService.new(cadastre: @cadastre)
          
          @service.create_notification do |service| 
            service.category_id = 2
            service.title       = title.html_safe
            service.content     = message.html_safe
            service.link        = ''
            service.push        = push
          end
        end

      end

      def upload_required 

          return false if @context_id.nil?
          
          case @context_id
          when 1
          
          if (@cadastre.main_income != @cadastre_mirror.main_income) || @cadastre.current_situation_id == 3
            @ticket.income_uploads.new if !@ticket.income_uploads.present?
          end

          if (@cadastre.rg != @cadastre_mirror.rg) ||
             (@cadastre.born != @cadastre_mirror.born) ||
             @cadastre.current_situation_id == 3

            @ticket.rg_uploads.new if !@ticket.rg_uploads.present?
          end

          if @cadastre.current_situation_id == 3 ||
            @cadastre.arrival_df != @cadastre_mirror.arrival_df
            @ticket.arrival_df_uploads.new if !@ticket.arrival_df_uploads.present?
          end 
   
          if @cadastre.current_situation_id == 3
            @cadastre.payment_uploads.new if !@ticket.payment_uploads.present?
          end

          if @cadastre.current_situation_id == 3
            @ticket.residence_uploads.new if !@ticket.residence_uploads.present?
          end
          
          if @cadastre.current_situation_id == 3
            @ticket.registry_uploads.new if !@ticket.registry_uploads.present?
          end

          if ((@cadastre.special_condition_id != @cadastre_mirror.special_condition_id) &&
              @cadastre_mirror.special_condition_id == 2) ||
              (@cadastre.current_situation_id == 3 && @cadastre_mirror.special_condition_id == 2)
              @ticket.special_condition_uploads.new if !@ticket.special_condition_uploads.present?
          end 

        when 2
          @dependent = @ticket.cadastre_mirror.dependent_mirrors.find(@dependent_mirror_id)
          
          if @dependent.income.to_i != 0
            @ticket.income_uploads.new if !@ticket.income_uploads.present?
          end

          if @dependent.is_major? 
            @ticket.cpf_uploads.new if !@ticket.cpf_uploads.present?
          end

          @ticket.certificate_born_uploads.new if !@ticket.certificate_born_uploads.present?
          
          if @dependent.special_condition_id == 2
            @ticket.special_condition_uploads.new if !@ticket.special_condition_uploads.present?
          end

        when 3

          count = @cadastre_mirror.dependent_mirrors

          count.times do
            @ticket.income_uploads.new if count < @ticket.income_uploads.count
          end

        end
      end


      private

      
      def clone_cadastre_to_make_mirror!
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


      def render_message(view)
        view_context.render "ticket_service/#{view}_message", ticket: @ticket
      end

    end
  end
end
