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
          if dependent.created_at != dependent.updated_at
            "<label class='ui label blue'>Atualizado</label>".html_safe
          else
            "<label class='ui label gray'>Sem ação</label>".html_safe
          end
        else
          "<label class='ui label green'>Novo</label>".html_safe
        end
      end
    
    end
  end
end
