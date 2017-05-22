require_dependency 'core/application_presenter'

module Core
  module Protocol
    class ConductPresenter < GeneralPresenter # :nodoc:
      def conduct_type_color_icon
        case self.conduct_type
        when 'doc_create'
          @color = 'grey'
          @icon = 'file'
        when 'doc_sent'
          @color = 'green'
          @icon = 'send'
        when 'doc_receive'
          @color = 'blue'
          @icon = 'checkmark'
        when 'doc_return'
          @color = 'yellow'
          @icon = 'reply'
        when 'doc_cancel'
          @color = 'brown'
          @icon = 'remove'
        end
        return [@color, @icon]
      end


    end
  end
end
