require_dependency 'core/application_presenter'

module Core
  module Candidate
    class CadastreMirrorPresenter < ApplicationPresenter

      def field_updated? value
        original_value = self.cadastre.send(value)
        new_value      = self.send(value)

        original_value != new_value ? 'positive' : ''
      end


      def field_updated_title value
        return nil unless (field_updated? value) == 'positive'
        
        original_value = self.cadastre.send(value)

        return "Valor original: #{original_value}"
      end
    
    end
  end
end
