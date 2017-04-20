require_dependency 'core/application_presenter'

module Core
  module Project
    class EnterprisePresenter < ApplicationPresenter
      
      def detail_name
        ent_object = self.enterprise_typologies.first rescue nil

        if ent_object.present?
          "#{ent_object.description} <br/> Valor: R$ #{ent_object.initial_value
          } a R$ #{ent_object.end_value}".html_safe rescue nil
        else 
          "Sem informação"
        end
      end

    end
  end
end