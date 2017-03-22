require_dependency 'core/application_presenter'

module Core
  module Attendance
    class ContextPresenter < ApplicationPresenter
      
      def link_to_action(context_id)
        context = CoreAttendance::TicketContext.find(context_id) rescue nil
        
        if !context.nil?
          ticket = self.tickets.where(ticket_context_id: context_id, status: true).last
          context_icon = set_context_icon(ticket)
          
          if ticket.present?
            link = h.link_to context.name.humanize, h.ticket_path(ticket)
            set_html_link(set_context_icon(ticket), link, ticket.ticket_status.name)
          else
            link = h.link_to context.name.humanize, h.context_pre_create_path(context_id), remote: true
            set_html_link(set_context_icon(ticket, context_id), link, "Clique para iniciar a atualização")
          end

        else 
          "#"
        end
      end


      private

      def set_html_link context_icon, link, content_text
        h.content_tag(:h4,class: "ui image header") do
          h.concat(h.content_tag(:i, '', class: "icon #{context_icon}"))
          h.concat(
            h.content_tag(:div, class: "content") do
              h.concat(link)
              h.concat(h.content_tag(:div, "#{content_text}",class: ["sub", "header"]))
            end
          )
        end 
      end

      def set_context_icon ticket = nil, context_id = nil
        if !ticket.nil?
          if ticket.ticket_status_id == 1
            'flag green'
          elsif [3,4].include? ticket.ticket_status_id
            'flag yellow'
          end
        else
          case context_id
          when 1
            'user'
          when 2
            'users'
          when 3
            'dollar'
          when 4
            'phone'
          end
        end
      end
    end
  end
end

