require_dependency 'core/application_presenter'

module Core
  module Manager
    class TaskPresenter < ApplicationPresenter
      
      def situation
        if self.solved
          return "<div class='ui label green'> Finalizada #{self.solved_date.strftime('%d/%m/%Y')}</div>".html_safe
        else
          return "<div class='ui label gray'> Pendente </div>".html_safe
        end
      end

    end
  end
end    