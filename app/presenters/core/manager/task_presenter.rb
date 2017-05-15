require_dependency 'core/application_presenter'

module Core
  module Manager
    class TaskPresenter < ApplicationPresenter
      
      def expired?
        return false if !self.due.present?

        (self.due < Date.current && !self.solved)
      end

      def situation
        if self.solved
          return "<div class='ui label green'> Finalizada #{self.solved_date.strftime('%d/%m/%Y')}</div>".html_safe
        else
          return "<div class='ui label gray'> Pendente </div>".html_safe
        end
      end

      def responsible_name
        html = ""

        sector      = self.sector.acron      rescue nil
        responsible = self.responsible.name rescue nil

        if !sector.nil?
          html += "#{sector}"
        end

        if !responsible.nil?
          html += " - " if !sector.nil?
          html += "#{responsible}"
        end

        return html.html_safe

      end

    end
  end
end    