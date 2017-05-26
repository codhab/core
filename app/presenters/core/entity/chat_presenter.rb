require_dependency 'core/application_presenter'

module Core
  module Entity
    class ChatPresenter < ApplicationPresenter

      def protocol
        "#{self.id}/#{self.created_at.strftime('%Y')}"
      end

    end
  end
end
