require_dependency 'core/application_presenter'

module Core
  module Manager
    class TaskPresenter < ApplicationPresenter
        
       # task situation: ['aguardando', 'pendente', 'em_progresso', 'fechada']

      def expired?
        return false if !self.due.present?

        (self.due < Date.current && !self.fechada?)
      end

      def start_in
        (self.due - self.due_days).strftime("%d/%m/%Y") rescue nil 
      end

      def situation_label
        if self.aguardando?
          return "<div class='ui ribbon label gray' style='padding: 8px'>Aguardando</div>".html_safe
        end

        if self.pendente?
          return "<div class='ui ribbon label yellow' style='padding: 8px'>Pendente</div>".html_safe
        end

        if self.em_progresso?
          return "<div class='ui ribbon label blue' style='padding: 8px'>Em execução</div>".html_safe
        end

        if self.fechada?
          return "<div class='ui ribbon label green' style='padding: 8px'> #{self.situation} #{self.solved_date.strftime('%d/%m/%Y')}</div>".html_safe
        end

      end

      def responsible_name
        html = ""

        sector      = self.sector.acron      rescue nil
        responsible = self.responsible.name rescue nil

        if !sector.nil?
          html += "<p><b>#{sector}</b></p>"
        end

        if !responsible.nil?
          html += "#{responsible}"
        end

        return html.html_safe

      end



    end
  end
end    