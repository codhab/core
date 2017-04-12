require_dependency 'core/application_presenter'

module Core
  module Candidate
    class DependentMirrorPresenter < ApplicationPresenter

      def action
        
        dependent = self.cadastre_mirror.cadastre.dependents.find(self.dependent_id) rescue nil

        if dependent.nil?
          dependent = self.cadastre_mirror.cadastre.dependents.find_by_name(self.name) rescue nil
        end
        
        if !dependent.nil?
          if self.created_at != self.updated_at
            "<label class='ui label blue'>Atualizado</label>".html_safe
          else
            "<label class='ui label gray'>Sem ação</label>".html_safe
          end
        else
          "<label class='ui label green'>Novo</label>".html_safe
        end
      end
      


      def field_updated? value
        original_value = self.dependent.send(value) rescue nil
        new_value      = self.send(value) rescue nil

        original_value != new_value ? 'positive' : ''
      end


      def field_updated_title value
        return nil unless (field_updated? value) == 'positive'
        
        original_value = self.cadastre.send(value) rescue nil 

        return "Valor original: #{original_value}"
      end
    end
  end
end
