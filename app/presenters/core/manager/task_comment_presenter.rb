require_dependency 'core/application_presenter'

module Core
  module Manager
    class TaskCommentPresenter < ApplicationPresenter
        
      def title
        html      =  ""
        commenter = self.commenter.name rescue nil
        
        html += "#{self.created_at.strftime("%d/%m/%Y - %H:%M")}"

        html += "- #{commenter}" if !commenter.nil?
        
        return html.html_safe
      end


      

    end
  end
end    