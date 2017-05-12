require_dependency 'core/application_presenter'

module Core
  module Manager
    class ProjectPresenter < ApplicationPresenter
    
      def progress
        total  = self.tasks.where(solved: true).count.to_f
        solved = self.tasks.count.to_f

        return 0 if solved.to_i == 0

        ((total / solved).to_f * 100).round(2)     
      end

    end
  end
end