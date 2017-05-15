require_dependency 'core/application_presenter'

module Core
  module Manager
    class ProjectPresenter < ApplicationPresenter
    
      def progress
        total  = self.tasks.where(solved: true).count.to_f
        solved = self.tasks.count.to_f

        return 0 if solved.to_i == 0

        ((total / solved).to_f * 100).round(1)     
      end

      def alert
        
        html  = ""

        problems = self.problems.where(solved: false)
        tasks    = self.tasks.where("due::date < ? and solved is false", Date.current.strftime('%Y-%m-%d'))

        if problems.present?
          html += "<div class='ui label red hyper-tiny mini-margin-bottom'>Problemas (#{problems.count})</div>"
        end

        if tasks.present?
          html += "<div class='ui label red hyper-tiny mini-margin-bottom'>Atrasado</div>"
        end

        return html.html_safe

      end

      def complete_title
        html = ""

        if self.responsible_sector.present?
          html += "#{self.responsible_sector.acron}"
        end

        if self.assessment.present?
          html += " | #{self.assessment}"
        end

        html += " | #{self.name}"


        return html.html_safe
      end

      def responsible_name
        self.responsible.name.titleize rescue nil
      end

      def manager_name
        self.manager.name.titleize rescue nil
      end

      def ended_at
        self.tasks.maximum(:due).strftime("%d/%m/%Y") rescue nil
      end


      def started_at
        self.start.strftime("%d/%m/%Y") rescue nil
      end
    end
  end
end